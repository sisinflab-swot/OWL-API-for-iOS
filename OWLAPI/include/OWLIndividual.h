//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"
#import "OWLPropertyAssertionObject.h"

@protocol OWLClassExpression;
@protocol OWLNamedIndividual;
@protocol OWLOntology;

NS_ASSUME_NONNULL_BEGIN

/// Represents a named or anonymous individual.
@protocol OWLIndividual <OWLObject, OWLPropertyAssertionObject>

/// Determines if this object is an instance of OWLAnonymousIndividual.
@property (nonatomic, readonly) BOOL anonymous;

/// Determines if this object is an instance of OWLNamedIndividual.
@property (nonatomic, readonly) BOOL named;

/**
 * Obtains this individual as a named individual if it is indeed named.
 *
 * @return The individual as a named individual, or nil if it is not named. 
 */
- (nullable id<OWLNamedIndividual>)asOWLNamedIndividual;

@end

NS_ASSUME_NONNULL_END
