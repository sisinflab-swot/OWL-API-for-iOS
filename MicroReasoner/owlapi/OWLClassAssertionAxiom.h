//
//  OWLClassAssertionAxiom.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLIndividualAxiom.h"

@protocol OWLClassExpression;
@protocol OWLIndividual;

NS_ASSUME_NONNULL_BEGIN

/// Represents ClassAssertion axioms in the OWL 2 Specification.
@protocol OWLClassAssertionAxiom <OWLIndividualAxiom>

/// The class expression that is asserted to be a type for an individual by this axiom.
@property (nonatomic, copy, readonly) id<OWLClassExpression> classExpression;

/// The individual that is asserted to be an instance of a class expression by this axiom.
@property (nonatomic, copy, readonly) id<OWLIndividual> individual;

@end

NS_ASSUME_NONNULL_END
