//
//  OWLObjectPropertyImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 08/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyImpl.h"

@implementation OWLObjectPropertyImpl

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature { return [NSSet setWithObject:self]; };

#pragma mark OWLNamedObject

@synthesize IRI = _IRI;

#pragma mark OWLEntity

- (BOOL)isOWLClass { return NO; }

#pragma mark OWLPropertyExpression

- (BOOL)anonymous { return NO; }

#pragma mark OWLObjectPropertyExpression

- (id<OWLObjectProperty>)asOWLObjectProperty { return self; }

#pragma mark Other public methods

- (instancetype)initWithIRI:(NSURL *)IRI
{
    NSParameterAssert(IRI);
    
    if ((self = [super init])) {
        _IRI = [IRI copy];
    }
    return self;
}

@end
