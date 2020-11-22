//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLLogicalAxiomImpl.h"
#import "OWLSubClassOfAxiom.h"

#import <cowl_compat.h>

cowl_struct_decl(CowlSubClsAxiom);

NS_ASSUME_NONNULL_BEGIN

@interface OWLSubClassOfAxiomImpl : OWLLogicalAxiomImpl <OWLSubClassOfAxiom>

- (instancetype)initWithCowlAxiom:(CowlSubClsAxiom *)axiom retain:(BOOL)retain;
- (instancetype)initWithSuperClass:(id<OWLClassExpression>)superClass
                          subClass:(id<OWLClassExpression>)subClass;

@end

NS_ASSUME_NONNULL_END
