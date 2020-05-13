//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLLogicalAxiomImpl.h"
#import "OWLObjectPropertyRangeAxiom.h"
#import "cowl_compat.h"

cowl_struct_decl(CowlObjPropRangeAxiom);

NS_ASSUME_NONNULL_BEGIN

@interface OWLObjectPropertyRangeAxiomImpl : OWLLogicalAxiomImpl <OWLObjectPropertyRangeAxiom>

- (instancetype)initWIthCowlAxiom:(CowlObjPropRangeAxiom *)axiom retain:(BOOL)retain;
- (instancetype)initWithProperty:(id<OWLObjectPropertyExpression>)property
                           range:(id<OWLClassExpression>)range;

@end

NS_ASSUME_NONNULL_END
