//
//  Created by Ivano Bilenchi on 10/05/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import "khash.h"

KHASH_DECLARE(OWLMap, kh_cstr_t, void *)

typedef khash_t(OWLMap) OWLMap;

/// Creates a new map.
extern OWLMap * owl_map_init(void);

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
