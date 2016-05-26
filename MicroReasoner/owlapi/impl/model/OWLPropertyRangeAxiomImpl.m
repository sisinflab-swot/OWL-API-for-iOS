//
//  OWLPropertyRangeAxiomImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLPropertyRangeAxiomImpl.h"
#import "OWLPropertyExpression.h"
#import "OWLPropertyRange.h"

@implementation OWLPropertyRangeAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        id objRange = [(id<OWLPropertyRangeAxiom>)object range];
        
        equal = (objRange == _range || [objRange isEqual:_range]);
    }
    
    return equal;
}

- (NSUInteger)computeHash { return [super computeHash] ^ [_range hash]; }

- (NSString *)description
{
    return [NSString stringWithFormat:@"Range(%@ %@)", self.property, _range];
}

#pragma mark OWLPropertyRangeAxiom

@synthesize range = _range;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLPropertyExpression>)property range:(id<OWLPropertyRange>)range
{
    NSParameterAssert(range);
    
    if ((self = [super initWithProperty:property])) {
        _range = [(id)range copy];
    }
    return self;
}

@end
