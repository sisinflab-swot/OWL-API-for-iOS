//
//  Created by Ivano Bilenchi on 14/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cowl_error.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const OWLErrorDomain;

typedef NS_ENUM(NSInteger, OWLErrorCode) {
    OWLErrorCodeGeneric,
    OWLErrorCodeParse,
    OWLErrorCodeSyntax
};

/// NSError convenience category.
@interface NSError (OWLError)

+ (NSError *)OWLErrorWithCowlError:(CowlError)error;
+ (NSError *)OWLErrorWithCode:(OWLErrorCode)code
         localizedDescription:(nullable NSString *)description;
+ (NSError *)OWLErrorWithCode:(OWLErrorCode)code
         localizedDescription:(nullable NSString *)description
                     userInfo:(nullable NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
