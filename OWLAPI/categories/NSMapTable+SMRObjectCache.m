//
//  Created by Ivano Bilenchi on 25/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "NSMapTable+SMRObjectCache.h"

#pragma mark Double level object cache key

@interface SMRObjectCacheKey : NSObject
{
    id _l1Key;
    id _l2Key;
}
@end


@implementation SMRObjectCacheKey

- (id)initWithL1Key:(id)l1Key l2Key:(id)l2Key
{
    NSParameterAssert(l1Key && l2Key);
    
    if ((self = [super init]))
    {
        _l1Key = l1Key;
        _l2Key = l2Key;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    SMRObjectCacheKey *key = object;
    return (_l1Key == key->_l1Key || [_l1Key isEqual:key->_l1Key]) && (_l2Key == key->_l2Key || [_l2Key isEqual:key->_l2Key]);
}

- (NSUInteger)hash { return [_l1Key hash] * 92821 ^ [_l2Key hash]; }

@end

#pragma mark - Object cache

@implementation NSMapTable (SMRObjectCache)

+ (NSMapTable *)smr_objCache { return [NSMapTable weakToWeakObjectsMapTable]; }

#pragma mark Double level object cache

- (id)smr_objCacheGetForKey1:(id)key1 key2:(id)key2
{
    SMRObjectCacheKey *key = [[SMRObjectCacheKey alloc] initWithL1Key:key1 l2Key:key2];
    return [self objectForKey:key];
}

- (void)smr_objCacheSet:(id)obj forKey1:(id)key1 key2:(id)key2
{
    SMRObjectCacheKey *key = [[SMRObjectCacheKey alloc] initWithL1Key:key1 l2Key:key2];
    [self setObject:obj forKey:key];
}

- (void)smr_objCacheRemoveForKey1:(id)key1 key2:(id)key2
{
    SMRObjectCacheKey *key = [[SMRObjectCacheKey alloc] initWithL1Key:key1 l2Key:key2];
    [self removeObjectForKey:key];
}

@end
