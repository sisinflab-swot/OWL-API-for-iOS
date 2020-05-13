//
//  Created by Ivano Bilenchi on 27/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLLogicalAxiomImpl.h"
#import "OWLTransitiveObjectPropertyAxiom.h"
#import "cowl_compat.h"

cowl_struct_decl(CowlObjPropCharAxiom);

NS_ASSUME_NONNULL_BEGIN

@interface OWLObjectPropertyCharacteristicAxiomImpl : OWLLogicalAxiomImpl
<OWLTransitiveObjectPropertyAxiom>

- (instancetype)initWithCowlAxiom:(CowlObjPropCharAxiom *)axiom retain:(BOOL)retain;
- (instancetype)initTransitiveObjectProperty:(id<OWLObjectPropertyExpression>)property;

@end

NS_ASSUME_NONNULL_END
