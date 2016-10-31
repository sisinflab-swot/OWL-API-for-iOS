//
//  Created by Ivano Bilenchi on 19/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SMRStringUtils)

/**
 * Checks if the receiver represents an integer. If it does,
 * returns its integer value via out parameter.
 *
 * @param integerValue NSInteger out parameter.
 *
 * @return Whether or not the receiver represents an integer.
 */
- (BOOL)smr_hasIntegerValue:(NSInteger *)integerValue;

@end
