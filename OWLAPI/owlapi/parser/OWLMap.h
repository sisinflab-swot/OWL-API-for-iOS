//
//  Created by Ivano Bilenchi on 10/05/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "khash.h"

__KHASH_TYPE(OWLMap, unsigned char *, void *)
typedef khash_t(OWLMap) OWLMap;

/// Creates a new map.
extern OWLMap * owl_map_init(void);

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

/**
 Map value setter.
 
 @param map The map.
 @param key The key.
 @param value The value.
 */
extern void owl_map_set(OWLMap *map, unsigned char *key, void *value);

#pragma mark Obj-C values API

/// Deallocates an existing map.
extern void owl_map_dealloc_obj(OWLMap *map);

/**
 Map value getter.
 
 @param map The map.
 @param key The key.
 
 @return Value associated with the specified key, or NULL if it does not exist.
 */
extern id owl_map_get_obj(OWLMap *map, unsigned char *key);

/**
 Map value setter.
 
 @param map The map.
 @param key The key.
 @param value The value.
 */
extern void owl_map_set_obj(OWLMap *map, unsigned char *key, id value);

/**
 Iterates over the map while deallocating its values, and finally deallocates the map itself.
 
 @param map The map.
 @param handler Handler for the map values.
 */
extern void owl_map_iterate_and_dealloc_obj(OWLMap *map, void (^handler)(id value));
