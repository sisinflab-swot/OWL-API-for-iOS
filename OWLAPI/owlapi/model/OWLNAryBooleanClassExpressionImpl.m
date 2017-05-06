//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLNAryBooleanClassExpressionImpl.h"

@implementation OWLNAryBooleanClassExpressionImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        NSSet *objOperands = ((OWLNAryBooleanClassExpressionImpl *)object)->_operands;
        equal = (objOperands == _operands || [objOperands isEqualToSet:_operands]);
    }
    
    return equal;
}

- (NSUInteger)computeHash
{
    NSUInteger hash = 0;
    
    for (id<OWLClassExpression> ce in _operands) {
        hash ^= [ce hash];
    }
    
    return hash;
}

#pragma mark OWLObject

- (NSMutableSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = nil;
    
    for (id<OWLClassExpression> op in _operands) {
        if (!signature) {
            signature = [op signature];
        } else {
            [signature unionSet:[op signature]];
        }
    }
    
    return signature ?: [NSMutableSet set];
}

#pragma mark OWLNAryBooleanClassExpression

@synthesize operands = _operands;

#pragma mark Other public methods

- (instancetype)initWithOperands:(NSSet<id<OWLClassExpression>> *)operands
{
    NSParameterAssert(operands.count);
    
    if ((self = [super init])) {
        _operands = [operands copy];
    }
    return self;
}

@end
