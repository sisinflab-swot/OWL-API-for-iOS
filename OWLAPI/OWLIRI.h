//
//  Created by Ivano Bilenchi on 16/02/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents International Resource Identifiers.
@interface OWLIRI : NSObject <NSCopying>

/// The string representation of this IRI.
@property (nonatomic, copy, readonly) NSString *string;

/**
 * Creates an IRI from the specified string.
 *
 * @param string The string that specifies the IRI
 *
 * @return The IRI that has the specified string representation.
 */
- (instancetype)initWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
