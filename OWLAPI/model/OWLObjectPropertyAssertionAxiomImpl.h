//
//  Created by Ivano Bilenchi on 22/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLLogicalAxiomImpl.h"
#import "OWLObjectPropertyAssertionAxiom.h"
#import "cowl_compat.h"

cowl_struct_decl(CowlObjPropAssertAxiom);

NS_ASSUME_NONNULL_BEGIN

@interface OWLObjectPropertyAssertionAxiomImpl : OWLLogicalAxiomImpl <OWLObjectPropertyAssertionAxiom>

- (instancetype)initWithCowlAxiom:(CowlObjPropAssertAxiom *)axiom retain:(BOOL)retain;
- (instancetype)initWithSubject:(id<OWLIndividual>)subject
                       property:(id<OWLObjectPropertyExpression>)property
                         object:(id<OWLIndividual>)object;

@end

NS_ASSUME_NONNULL_END
