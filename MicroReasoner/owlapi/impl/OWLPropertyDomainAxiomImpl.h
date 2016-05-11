//
//  OWLPropertyDomainAxiomImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLUnaryPropertyAxiomImpl.h"
#import "OWLPropertyDomainAxiom.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLPropertyDomainAxiom protocol.
@interface OWLPropertyDomainAxiomImpl : OWLUnaryPropertyAxiomImpl

#pragma mark OWLPropertyDomainAxiom

@property (nonatomic, copy, readonly) id<OWLClassExpression> domain;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLPropertyExpression>)property domain:(id<OWLClassExpression>)domain;

@end

NS_ASSUME_NONNULL_END
