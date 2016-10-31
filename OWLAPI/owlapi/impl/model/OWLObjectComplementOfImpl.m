//
//  Created by Ivano Bilenchi on 22/09/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectComplementOfImpl.h"

@implementation OWLObjectComplementOfImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        id objOperand = [(id<OWLObjectComplementOf>)object operand];
        
        equal = (objOperand == _operand || [objOperand isEqual:_operand]);
    }
    
    return equal;
}

- (NSUInteger)computeHash { return [_operand hash]; }

- (NSString *)description
{
    return [NSString stringWithFormat:@"ObjectComplementOf(%@)", _operand];
}

#pragma mark OWLObject

- (NSMutableSet<id<OWLEntity>> *)signature
{
    return [NSMutableSet setWithObject:_operand];
}

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType { return OWLClassExpTypeObjectComplementOf; }

#pragma mark OWLObjectComplementOf

@synthesize operand = _operand;

#pragma mark Other public methods

- (instancetype)initWithOperand:(id<OWLClassExpression>)operand
{
    NSParameterAssert(operand);
    
    if ((self = [super init])) {
        _operand = [(id)operand copy];
    }
    
    return self;
}

@end
