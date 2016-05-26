//
//  OWLSubClassOfAxiom.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClassAxiom.h"

@protocol OWLClassExpression;

NS_ASSUME_NONNULL_BEGIN

/// Represents a SubClassOf axiom in the OWL 2 Specification.
@protocol OWLSubClassOfAxiom <OWLClassAxiom>

/// The subclass in this axiom.
@property (nonatomic, copy, readonly) id<OWLClassExpression> subClass;

/// The superclass in this axiom.
@property (nonatomic, copy, readonly) id<OWLClassExpression> superClass;

@end

NS_ASSUME_NONNULL_END
