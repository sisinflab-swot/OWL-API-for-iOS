//
//  Created by Ivano Bilenchi on 24/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (SMRMutableDictionaryUtils)

- (void)smr_enumerateAndRemoveKeysAndObjectsUsingBlock:(void (^)(id _Nonnull key, id _Nonnull obj))block;

@end

NS_ASSUME_NONNULL_END
