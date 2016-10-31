//
//  Created by Ivano Bilenchi on 25/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMapTable (SMRObjectCache)

+ (NSMapTable *)smr_objCache;

#pragma mark Double level object cache

- (id)smr_objCacheGetForKey1:(id)key1 key2:(id)key2;
- (void)smr_objCacheSet:(id)obj forKey1:(id)key1 key2:(id)key2;
- (void)smr_objCacheRemoveForKey1:(id)key1 key2:(id)key2;

@end
