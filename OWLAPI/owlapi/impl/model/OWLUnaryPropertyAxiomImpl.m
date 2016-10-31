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
        
        equal = (objProperty == _property || [object isEqual:_property]);
    }
    
    return equal;
}

- (NSUInteger)computeHash { return [_property hash]; }

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
