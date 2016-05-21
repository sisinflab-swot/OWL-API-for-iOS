//
//  OWLRestrictionImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLRestrictionImpl.h"
#import "OWLObjectPropertyExpression.h"

@implementation OWLRestrictionImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        id objProperty = [object property];
        
        equal = (objProperty == _property || [objProperty isEqual:_property]);
    }
    
    return equal;
}

- (NSUInteger)computeHash { return [_property hash]; }

#pragma mark OWLRestriction

@synthesize property = _property;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLPropertyExpression>)property
{
    NSParameterAssert(property);
    
    if ((self = [super init])) {
        _property = property;
    }
    return self;
}

@end
