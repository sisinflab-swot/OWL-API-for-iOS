//
//  Created by Ivano Bilenchi on 22/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLIndividualAxiom.h"

@protocol OWLIndividual;
@protocol OWLPropertyAssertionObject;
@protocol OWLPropertyExpression;

NS_ASSUME_NONNULL_BEGIN

/// Represents a Property Assertion in the OWL 2 specification.
@protocol OWLPropertyAssertionAxiom <OWLIndividualAxiom>

/// The subject of this assertion.
@property (nonatomic, copy, readonly) id<OWLIndividual> subject;

/// The property of this assertion.
@property (nonatomic, copy, readonly) id<OWLPropertyExpression> property;

/// The individual of this assertion.
@property (nonatomic, copy, readonly) id<OWLPropertyAssertionObject> object;

@end

NS_ASSUME_NONNULL_END
