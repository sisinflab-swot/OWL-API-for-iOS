//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLPropertyRangeAxiom.h"
#import "OWLClassExpression.h"
#import "OWLObjectPropertyAxiom.h"
#import "OWLObjectPropertyExpression.h"

NS_ASSUME_NONNULL_BEGIN

/// Represents ObjectPropertyRange axioms in the OWL 2 specification.
@protocol OWLObjectPropertyRangeAxiom <OWLPropertyRangeAxiom, OWLObjectPropertyAxiom>

#pragma mark OWLUnaryPropertyAxiom

/// The property expression that this axiom describes.
@property (nonatomic, copy, readonly) id<OWLObjectPropertyExpression> property;

#pragma mark OWLPropertyRangeAxiom

/// The range specified by this axiom.
@property (nonatomic, copy, readonly) id<OWLClassExpression> range;

@end

NS_ASSUME_NONNULL_END
