//
//  Created by Ivano Bilenchi on 09/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLLogicalAxiomImpl.h"
#import "OWLDisjointClassesAxiom.h"
#import "OWLEquivalentClassesAxiom.h"

#import <cowl_compat.h>

cowl_struct_decl(CowlNAryClsAxiom);

NS_ASSUME_NONNULL_BEGIN

@interface OWLNAryClassAxiomImpl : OWLLogicalAxiomImpl
<OWLEquivalentClassesAxiom, OWLDisjointClassesAxiom>

- (instancetype)initWithCowlAxiom:(CowlNAryClsAxiom *)axiom retain:(BOOL)retain;
- (instancetype)initWithDisjointClasses:(NSSet<id<OWLClassExpression>> *)classes;
- (instancetype)initWithEquivalentClasses:(NSSet<id<OWLClassExpression>> *)classes;

@end

NS_ASSUME_NONNULL_END
