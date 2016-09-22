//
//  OWLObjectComplementOfImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 22/09/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAnonymousClassExpressionImpl.h"
#import "OWLObjectComplementOf.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLObjectComplementOfImpl : OWLAnonymousClassExpressionImpl <OWLObjectComplementOf>

- (instancetype)initWithOperand:(id<OWLClassExpression>)operand;

@end

NS_ASSUME_NONNULL_END
