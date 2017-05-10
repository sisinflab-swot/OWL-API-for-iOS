//
//  Created by Ivano Bilenchi on 10/05/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import "OWLMap.h"

__KHASH_IMPL(OWLMap, /* none */ , kh_cstr_t, void *, 1, kh_str_hash_func, kh_str_hash_equal)

OWLMap * owl_map_init(void)
{
    return kh_init(OWLMap);
}

void owl_map_dealloc(OWLMap *map)
{
    for (khiter_t k = 0; k < kh_end(map); ++k) {
        if (kh_exist(map, k)) {
            free((char *)kh_key(map, k));
        }
    }
    
    kh_destroy(OWLMap, map);
}

void * owl_map_get(OWLMap *map, unsigned char *key)
{
    khiter_t k = kh_get(OWLMap, map, (kh_cstr_t)key);
    return k == kh_end(map) ? NULL : kh_val(map, k);
}

void owl_map_set(OWLMap *map, unsigned char *key, void *value)
{
    int absent;
    khiter_t k = kh_put(OWLMap, map, (kh_cstr_t)key, &absent);
    if (absent) {
        kh_key(map, k) = strdup((kh_cstr_t)key);
    }
    kh_value(map, k) = value;
}
