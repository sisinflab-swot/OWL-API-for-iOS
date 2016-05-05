//
//  OWLSubClassOfAxiomImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLSubClassOfAxiom.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLSubClassOfAxiomImpl : OWLObjectImpl <OWLSubClassOfAxiom>

- (instancetype)initWithSuperClass:(id<OWLClassExpression>)superClass subClass:(id<OWLClassExpression>)subClass;

@end

NS_ASSUME_NONNULL_END
