//
//  OWLObjectPropertyDomainAxiom.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLPropertyDomainAxiom.h"
#import "OWLObjectPropertyAxiom.h"
#import "OWLObjectPropertyExpression.h"

NS_ASSUME_NONNULL_BEGIN

/// Represents ObjectPropertyDomain axioms in the OWL 2 specification.
@protocol OWLObjectPropertyDomainAxiom <OWLPropertyDomainAxiom, OWLObjectPropertyAxiom>

#pragma mark OWLUnaryPropertyAxiom

@property (nonatomic, copy, readonly) id<OWLObjectPropertyExpression> property;

@end

NS_ASSUME_NONNULL_END
