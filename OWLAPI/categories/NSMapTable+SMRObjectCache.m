//
//  Created by Ivano Bilenchi on 25/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "NSMapTable+SMRObjectCache.h"

@implementation NSMapTable (SMRObjectCache)

+ (NSMapTable *)smr_objCache { return [NSMapTable weakToWeakObjectsMapTable]; }

#pragma mark Double level object cache

- (id)smr_objCacheGetForKey1:(id)key1 key2:(id)key2
{
    return [(NSMapTable *)[self objectForKey:key1] objectForKey:key2];
}

- (void)smr_objCacheSet:(id)obj forKey1:(id)key1 key2:(id)key2
{
    NSMapTable *l2Cache = [self objectForKey:key1];
    if (!l2Cache) {
        l2Cache = [NSMapTable smr_objCache];
        [self setObject:l2Cache forKey:key1];
    }
    [l2Cache setObject:obj forKey:key2];
}

- (void)smr_objCacheRemoveForKey1:(id)key1 key2:(id)key2
{
    NSMapTable *l2Cache = [self objectForKey:key1];
    if (l2Cache) {
        [l2Cache removeObjectForKey:key2];
        
        if (!l2Cache.count) {
            [self removeObjectForKey:key1];
        }
    }
}

@end
