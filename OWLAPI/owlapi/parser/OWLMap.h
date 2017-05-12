//
//  Created by Ivano Bilenchi on 10/05/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum OWLMapOptions {
    NONE                = 0,
    STRONG_OBJ_VALUES   = 1 << 0
} OWLMapOptions;

typedef struct OWLMap OWLMap;

/// Creates a new map.
extern OWLMap * owl_map_init(OWLMapOptions options);

#pragma mark C values API

/// Deallocates an existing map.
extern void owl_map_dealloc(OWLMap *map);

/**
 Map value getter.
 
 @param map The map.
 @param key The key.
 
 @return Value associated with the specified key, or NULL if it does not exist.
 */
extern void * owl_map_get(OWLMap *map, unsigned char *key);

#if __has_feature(objc_arc)
    #define owl_map_get_obj(map, key) (__bridge id)(owl_map_get(map, key))
#else
    #define owl_map_get_obj(map, key) (id)(owl_map_get(map, key))
#endif


/**
 Map value setter.
 
 @param map The map.
 @param key The key.
 @param value The value.
 
 @return The internal copy of the key.
 */
extern unsigned char * owl_map_set(OWLMap *map, unsigned char *key, void *value);

#if __has_feature(objc_arc)
    #define owl_map_set_obj(map, key, value) owl_map_set(map, key, (__bridge void *)value)
#else
    #define owl_map_set_obj(map, key, value) owl_map_set(map, key, (void *)value)
#endif

/**
 Iterates over the map while deallocating its values, and finally deallocates the map itself.
 
 @param map The map.
 @param handler Handler for the map values.
 */
extern void owl_map_iterate_and_dealloc_obj(OWLMap *map, void (^handler)(id value));
