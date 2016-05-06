//
//  OWLRestrictionImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLRestrictionImpl.h"

@implementation OWLRestrictionImpl

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
