//
//  Created by Ivano Bilenchi on 24/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "NSMutableDictionary+SMRMutableDictionaryUtils.h"

@implementation NSMutableDictionary (SMRMutableDictionaryUtils)

- (void)smr_enumerateAndRemoveKeysAndObjectsUsingBlock:(void (^)(id _Nonnull, id _Nonnull))block
{
    NSUInteger const batchSize = 1000;
    NSMutableArray *keysToRemove = [[NSMutableArray alloc] initWithCapacity:batchSize];
    
    while (self.count) {
        @autoreleasepool {
            __block NSUInteger currentCount = 0;
            
            [self enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
                block(key, obj);
                
                [keysToRemove addObject:key];
                if (++currentCount == batchSize) {
                    *stop = YES;
                }
            }];
            
            [self removeObjectsForKeys:keysToRemove];
            [keysToRemove removeAllObjects];
        }
    }
}

@end
