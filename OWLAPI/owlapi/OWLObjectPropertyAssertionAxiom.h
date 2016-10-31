//
//  Created by Ivano Bilenchi on 22/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLPropertyAssertionAxiom.h"
#import "OWLIndividual.h"
#import "OWLObjectPropertyExpression.h"

NS_ASSUME_NONNULL_BEGIN

/// Represents an ObjectPropertyAssertion axiom in the OWL 2 Specification.
@protocol OWLObjectPropertyAssertionAxiom <OWLPropertyAssertionAxiom>

/// The property of this assertion.
@property (nonatomic, copy, readonly) id<OWLObjectPropertyExpression> property;

/// The individual of this assertion.
@property (nonatomic, copy, readonly) id<OWLIndividual> object;

@end

NS_ASSUME_NONNULL_END
