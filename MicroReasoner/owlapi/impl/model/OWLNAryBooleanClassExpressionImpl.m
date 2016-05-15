//
//  OWLNAryBooleanClassExpressionImpl.m
//  MicroReasoner
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
        NSSet *objOperands = [object operands];
        NSSet *selfOperands = self.operands;
        
        equal = (objOperands == selfOperands || [objOperands isEqualToSet:selfOperands]);
    }
    
    return equal;
}

- (NSUInteger)hash { return self.operands.hash; }

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [[NSMutableSet alloc] init];
    
    for (id<OWLClassExpression> op in self.operands) {
        [signature unionSet:[op signature]];
    }
    
    return signature;
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
