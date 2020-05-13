//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLLogicalAxiomImpl.h"
#import "OWLClassAssertionAxiom.h"
#import "cowl_compat.h"

cowl_struct_decl(CowlClsAssertAxiom);

NS_ASSUME_NONNULL_BEGIN

@interface OWLClassAssertionAxiomImpl : OWLLogicalAxiomImpl <OWLClassAssertionAxiom>

- (instancetype)initWithCowlAxiom:(CowlClsAssertAxiom *)axiom retain:(BOOL)retain;
- (instancetype)initWithIndividual:(id<OWLIndividual>)individual
                   classExpression:(id<OWLClassExpression>)classExpression;

@end

NS_ASSUME_NONNULL_END
