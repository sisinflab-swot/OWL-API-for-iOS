//
//  Created by Ivano Bilenchi on 16/02/17.
//  Copyright © 2017-2020 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents International Resource Identifiers.
@interface OWLIRI : NSObject <NSCopying>

/// @return The string representation of this IRI.
- (NSString *)string;

/// @return The namespace of this IRI.
- (NSString *)namespace;

/// @return The remainder of this IRI.
- (nullable NSString *)remainder;

/// @return The scheme of this IRI.
- (nullable NSString *)scheme;

/**
 * Creates an IRI from the specified string.
 *
 * @param string The string that specifies the IRI.
 *
 * @return The IRI that has the specified string representation.
 */
- (instancetype)initWithString:(NSString *)string;

/**
 * Creates an IRI from the specified C string.
 *
 * @param string The string that specifies the IRI (null terminated).
 *
 * @return The IRI that has the specified string representation.
 */
- (instancetype)initWithCString:(char const *)string;

/**
 * Compares two IRIs alphabetically.
 *
 * @param iri The IRI with which to compare the receiver.
 *
 * @return Value that indicates the lexical ordering.
 */
- (NSComparisonResult)compare:(OWLIRI *)iri;

@end

NS_ASSUME_NONNULL_END
