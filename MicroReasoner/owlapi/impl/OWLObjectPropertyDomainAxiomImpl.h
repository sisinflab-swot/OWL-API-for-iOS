//
//  OWLObjectPropertyDomainAxiomImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLPropertyDomainAxiomImpl.h"
#import "OWLObjectPropertyDomainAxiom.h"

@protocol OWLObjectPropertyExpression;

NS_ASSUME_NONNULL_BEGIN

@interface OWLObjectPropertyDomainAxiomImpl : OWLPropertyDomainAxiomImpl <OWLObjectPropertyDomainAxiom>

- (instancetype)initWithProperty:(id<OWLObjectPropertyExpression>)property domain:(id<OWLClassExpression>)domain;

@end

NS_ASSUME_NONNULL_END
