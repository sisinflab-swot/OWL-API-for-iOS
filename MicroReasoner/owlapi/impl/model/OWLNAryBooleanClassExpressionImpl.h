//
//  OWLNAryBooleanClassExpressionImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAnonymousClassExpressionImpl.h"
#import "OWLNAryBooleanClassExpression.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLNAryBooleanClassExpression protocol.
@interface OWLNAryBooleanClassExpressionImpl : OWLAnonymousClassExpressionImpl

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature;

#pragma mark OWLNAryBooleanClassExpression

@property (nonatomic, copy, readonly) NSSet<id<OWLClassExpression>> *operands;

#pragma mark Other public methods

- (instancetype)initWithOperands:(NSSet<id<OWLClassExpression>> *)operands;

@end

NS_ASSUME_NONNULL_END
