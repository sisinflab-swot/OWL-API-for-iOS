//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLLogicalAxiomImpl.h"
#import "OWLSubClassOfAxiom.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLSubClassOfAxiomImpl : OWLLogicalAxiomImpl <OWLSubClassOfAxiom>

- (instancetype)initWithSuperClass:(id<OWLClassExpression>)superClass subClass:(id<OWLClassExpression>)subClass;

@end

NS_ASSUME_NONNULL_END
