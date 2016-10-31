//
//  Created by Ivano Bilenchi on 19/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "NSString+SMRStringUtils.h"

@implementation NSString (SMRStringUtils)

- (BOOL)smr_hasIntegerValue:(NSInteger *)integerValue
{
    BOOL success = NO;
    NSInteger localInteger = 0;
    
    if ([self isEqualToString:@"0"]) {
        success = YES;
    } else {
        localInteger = [self integerValue];
        success = localInteger != 0;
    }
    
    if (integerValue) {
        *integerValue = localInteger;
    }
    return success;
}

@end
