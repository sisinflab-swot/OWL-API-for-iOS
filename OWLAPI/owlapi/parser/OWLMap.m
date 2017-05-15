//
//  Created by Ivano Bilenchi on 10/05/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import "OWLMap.h"
#import "khash.h"

#pragma mark Macros

#define owl_table_hash_func(key) kh_str_hash_func((kh_cstr_t)key)
#define owl_table_hash_equal(a, b) kh_str_hash_equal((kh_cstr_t)a, (kh_cstr_t)b)

KHASH_INIT(OWLTable, unsigned char *, void *, 1, owl_table_hash_func, owl_table_hash_equal)

#define kh_foreach_key(h, kvar, code) { khint_t __i;        \
for (__i = kh_begin(h); __i != kh_end(h); ++__i) {      \
if (!kh_exist(h,__i)) continue;                     \
(kvar) = kh_key(h,__i);                             \
code;                                               \
} }

#define has_option(options, option) ((options & option) == option)
#define owl_table_copy_key(key) ((unsigned char *)strdup((char *)key))


#pragma mark Struct definition

struct OWLMap {
    OWLMapOptions _options;
    khash_t(OWLTable) *_table;
};


#pragma mark Public functions

OWLMap * owl_map_init(OWLMapOptions options)
{
    OWLMap *map = malloc(sizeof(OWLMap));
    map->_options = options;
    map->_table = kh_init(OWLTable);
    return map;
}

void owl_map_dealloc(OWLMap *map)
{
    if (!map) return;
    
    khash_t(OWLTable) *table = map->_table;
    OWLMapOptions options = map->_options;
    
    if (table) {
        BOOL copyKeys = has_option(options, COPY_KEYS);
        
        if (has_option(options, STRONG_OBJ_VALUES)) {
            // Strong Objective-C values, release.
            unsigned char *key;
            void *value;
            
            kh_foreach(table, key, value, {
                if (copyKeys) {
                    free(key);
                }
                [(id)value release];
            });
        } else if (copyKeys) {
            // Weak Objective-C or C values with copied keys.
            unsigned char *key;
            kh_foreach_key(table, key, free(key));
        }
        kh_destroy(OWLTable, table);
    }
    
    free(map);
}

void * owl_map_get(OWLMap *map, unsigned char *key)
{
    khash_t(OWLTable) *table = map->_table;
    khiter_t k = kh_get(OWLTable, table, key);
    return k == kh_end(table) ? NULL : kh_val(table, k);
}

unsigned char * owl_map_set(OWLMap *map, unsigned char *key, void *value)
{
    unsigned char *local_key;
    
    khash_t(OWLTable) *table = map->_table;
    OWLMapOptions options = map->_options;
    
    BOOL objValues = has_option(options, STRONG_OBJ_VALUES);
    
    if (value) {
        // Grow the underlying storage if necessary.
        khint_t max_size = table->upper_bound;
        if (kh_size(table) >= max_size - 1) {
            kh_resize(OWLTable, table, max_size * 2);
        }
        
        int absent;
        khiter_t k = kh_put(OWLTable, table, key, &absent);
        
        if (absent) {
            if (has_option(options, COPY_KEYS)) {
                local_key = owl_table_copy_key(key);
            } else {
                local_key = key;
            }
            kh_key(table, k) = local_key;
        } else {
            if (objValues) {
                [(id)kh_val(table, k) release];
            }
            local_key = kh_key(table, k);
        }
        
        kh_value(table, k) = value;
        
        if (objValues) {
            [(id)value retain];
        }
    } else {
        khiter_t k = kh_get(OWLTable, table, key);
        
        if (k != kh_end(table)) {
            
            if (has_option(options, COPY_KEYS)) {
                free(kh_key(table, k));
            }
            kh_del(OWLTable, table, k);
            
            if (objValues) {
                [(id)kh_val(table, k) release];
            }
        }
        
        // Shrink the underlying storage if necessary.
        khint_t max_size = table->upper_bound;
        if (kh_size(table) < max_size / 4) {
            kh_resize(OWLTable, table, max_size / 2);
        }
        
        local_key = NULL;
    }
    
    
    return local_key;
}

void owl_map_iterate_obj(OWLMap *map, void (^handler)(id value))
{
    if (!map) return;
    
    void *value;
    
    kh_foreach_value(map->_table, value, {
        handler(value);
    });
}

void owl_map_iterate_and_dealloc_obj(OWLMap *map, void (^handler)(id value))
{
    if (!map) return;
    
    khash_t(OWLTable) *table = map->_table;
    OWLMapOptions options = map->_options;
    
    if (table) {
        BOOL objValues = has_option(options, STRONG_OBJ_VALUES);
        BOOL copyKeys = has_option(options, COPY_KEYS);
        
        unsigned char *key;
        void *value;
        
        kh_foreach(table, key, value, {
            handler(value);
            
            if (copyKeys) {
                free(key);
            }
            
            if (objValues) {
                [(id)value release];
            }
        });
        kh_destroy(OWLTable, table);
    }
    
    free(map);
}
