//
//  OWLError.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 14/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const OWLErrorDomain;

typedef NS_ENUM(NSInteger, OWLErrorCode) {
    OWLErrorCodeGeneric,
    OWLErrorCodeCumulative,
    OWLErrorCodeParse
};

/// NSError convenience category.
@interface NSError (OWLError)

+ (NSError *)OWLErrorWithCode:(NSInteger)code localizedDescription:(nullable NSString *)description;
+ (NSError *)OWLErrorWithCode:(NSInteger)code localizedDescription:(nullable NSString *)description userInfo:(nullable NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END