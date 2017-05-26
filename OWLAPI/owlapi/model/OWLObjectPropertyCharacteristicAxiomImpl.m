//
//  Created by Ivano Bilenchi on 27/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyCharacteristicAxiomImpl.h"

@implementation OWLObjectPropertyCharacteristicAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        id objProperty = ((OWLObjectPropertyCharacteristicAxiomImpl *)object)->_property;
        equal = (objProperty == _property || [object isEqual:_property]);
    }
    
    return equal;
}

- (NSUInteger)computeHash { return [_property hash]; }

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature { return [_property signature]; }

#pragma mark OWLObjectPropertyCharacteristicAxiom

@synthesize property = _property;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLObjectPropertyExpression>)property
{
    NSParameterAssert(property);
    
    if ((self = [super init])) {
        _property = [(id)property copy];
    }
    return self;
}

@end
