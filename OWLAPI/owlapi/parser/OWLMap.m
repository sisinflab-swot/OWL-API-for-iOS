//
//  Created by Ivano Bilenchi on 10/05/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import "OWLMap.h"

#define owl_map_hash_func(key) kh_str_hash_func((kh_cstr_t)key)
#define owl_map_hash_equal(a, b) kh_str_hash_equal((kh_cstr_t)a, (kh_cstr_t)b)

__KHASH_PROTOTYPES(OWLMap, unsigned char *, void *)
__KHASH_IMPL(OWLMap, /* none */ , unsigned char *, void *, 1, owl_map_hash_func, owl_map_hash_equal)

#define kh_foreach_key(h, kvar, code) { khint_t __i;        \
    for (__i = kh_begin(h); __i != kh_end(h); ++__i) {      \
        if (!kh_exist(h,__i)) continue;                     \
        (kvar) = kh_key(h,__i);                             \
        code;                                               \
    } }

OWLMap * owl_map_init(void)
{
    return kh_init(OWLMap);
}

#pragma mark - C values API

void owl_map_dealloc(OWLMap *map)
{
    if (!map)
        return;
    
    unsigned char * key;
    kh_foreach_key(map, key, free(key));
    kh_destroy(OWLMap, map);
}

void * owl_map_get(OWLMap *map, unsigned char *key)
{
    khiter_t k = kh_get(OWLMap, map, key);
    return k == kh_end(map) ? NULL : kh_val(map, k);
}

void owl_map_set(OWLMap *map, unsigned char *key, void *value)
{
    khint_t max_size = map->upper_bound;
    if (kh_size(map) >= max_size - 1) {
        kh_resize(OWLMap, map, max_size * 2);
    }
    
    int absent;
    khiter_t k = kh_put(OWLMap, map, key, &absent);
    if (absent) {
        kh_key(map, k) = (unsigned char *)strdup((char *)key);
    }
    kh_value(map, k) = value;
}

#pragma mark - Obj-C values API

void owl_map_dealloc_obj(OWLMap *map)
{
    if (!map)
        return;
    
    unsigned char * key;
    void *value;
    
    kh_foreach(map, key, value, {
        free(key);
        [(id)value release];
    });
    kh_destroy(OWLMap, map);
}

id owl_map_get_obj(OWLMap *map, unsigned char *key)
{
    khiter_t k = kh_get(OWLMap, map, key);
    return k == kh_end(map) ? nil : (id)kh_val(map, k);
}

void owl_map_set_obj(OWLMap *map, unsigned char *key, id value)
{
    khint_t max_size = map->upper_bound;
    if (kh_size(map) >= max_size - 1) {
        kh_resize(OWLMap, map, max_size * 2);
    }
    
    int absent;
    khiter_t k = kh_put(OWLMap, map, key, &absent);
    if (absent) {
        kh_key(map, k) = (unsigned char *)strdup((char *)key);
    } else {
        [(id)kh_val(map, k) release];
    }
    kh_value(map, k) = [value retain];
}

void owl_map_iterate_and_dealloc_obj(OWLMap *map, void (^handler)(id value))
{
    void *value;
    
    kh_foreach_value(map, value, {
        handler(value);
        [(id)value release];
    });
    
    owl_map_dealloc(map);
}
