//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLLogicalAxiomImpl.h"
#import "OWLObjectPropertyDomainAxiom.h"
#import "cowl_compat.h"

cowl_struct_decl(CowlObjPropDomainAxiom);

NS_ASSUME_NONNULL_BEGIN

@interface OWLObjectPropertyDomainAxiomImpl : OWLLogicalAxiomImpl <OWLObjectPropertyDomainAxiom>

- (instancetype)initWithCowlAxiom:(CowlObjPropDomainAxiom *)axiom retain:(BOOL)retain;
- (instancetype)initWithProperty:(id<OWLObjectPropertyExpression>)property
                          domain:(id<OWLClassExpression>)domain;

@end

NS_ASSUME_NONNULL_END
