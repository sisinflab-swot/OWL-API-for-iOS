//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAnonymousClassExpression.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OWLPropertyExpression;

/**
 * Represents a restriction (Object Property Restriction or Data Property Restriction)
 * in the OWL 2 specification.
 */
@protocol OWLRestriction <OWLAnonymousClassExpression>

/// The property/properties that the restriction acts along.
@property (nonatomic, strong, readonly) id<OWLPropertyExpression> property;

/// Determines if this is an object restriction.
@property (nonatomic, readonly) BOOL isObjectRestriction;

/// Determines if this is a data restriction.
@property (nonatomic, readonly) BOOL isDataRestriction;

@end

NS_ASSUME_NONNULL_END
