//
//  OWLUnaryPropertyAxiomImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLUnaryPropertyAxiomImpl.h"
#import "OWLPropertyExpression.h"

@implementation OWLUnaryPropertyAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        id objProperty = [object property];
        id selfProperty = self.property;
        
        equal = (objProperty == selfProperty || [object isEqual:selfProperty]);
    }
    
    return equal;
}

- (NSUInteger)hash { return [self.property hash]; }

#pragma mark OWLUnaryPropertyAxiom

@synthesize property = _property;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLPropertyExpression>)property
{
    NSParameterAssert(property);
    
    if ((self = [super init])) {
        _property = [(id)property copy];
    }
    return self;
}

@end
