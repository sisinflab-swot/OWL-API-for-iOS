//
//  Created by Ivano Bilenchi on 14/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLError.h"
#import "OWLCowlUtils.h"
#import "OWLDebug.h"

NSString *const OWLErrorDomain = @"it.poliba.sisinflab.owlapi-ios";

@implementation NSError (OWLError)

+ (NSError *)OWLErrorWithCowlError:(CowlError)error {
    return [self OWLErrorWithCode:(NSInteger)error.code
             localizedDescription:stringFromCowl(error.description, NO)];
}

+ (NSError *)OWLErrorWithCode:(OWLErrorCode)code localizedDescription:(NSString *)description {
    return [self OWLErrorWithCode:code localizedDescription:description userInfo:nil];
}

+ (NSError *)OWLErrorWithCode:(OWLErrorCode)code
         localizedDescription:(NSString *)description
                     userInfo:(NSDictionary *)userInfo {
    NSMutableDictionary *localUserInfo = nil;
    
    if (description || userInfo) {
        localUserInfo = userInfo ? [userInfo mutableCopy] : [[NSMutableDictionary alloc] init];
        
        if (description) {
            [localUserInfo setObject:description forKey:NSLocalizedDescriptionKey];
        }
    }
    
    OWLDebugLog(@"Error (Code %ld):\n%@", (long)code, localUserInfo);
    
    return [[NSError alloc] initWithDomain:OWLErrorDomain code:code userInfo:localUserInfo];
}

@end
