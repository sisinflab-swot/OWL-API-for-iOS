//
//  OWLObjectPropertyImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 08/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyImpl.h"

@implementation OWLObjectPropertyImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object { return object == self; }

- (NSUInteger)hash { return (NSUInteger)self; }

- (NSString *)description
{
    return [NSString stringWithFormat:@"ObjectProperty(<%@>)", [_IRI absoluteString]];
}

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature { return [NSSet setWithObject:self]; };

#pragma mark OWLNamedObject

@synthesize IRI = _IRI;

#pragma mark OWLEntity

- (OWLEntityType)entityType { return OWLEntityTypeObjectProperty; }

- (BOOL)isOWLClass { return NO; }

- (BOOL)isOWLNamedIndividual { return NO; }

- (BOOL)isOWLObjectProperty { return YES; }

#pragma mark OWLPropertyExpression

- (BOOL)anonymous { return NO; }

#pragma mark OWLObjectPropertyExpression

- (id<OWLObjectProperty>)asOWLObjectProperty { return self; }

#pragma mark Other public methods

static NSMapTable *instanceCache = nil;

+ (void)initialize
{
    if (self == [OWLObjectPropertyImpl class]) {
        instanceCache = [NSMapTable strongToWeakObjectsMapTable];
    }
}

- (instancetype)initWithIRI:(NSURL *)IRI
{
    NSParameterAssert(IRI);
    
    id cachedInstance = [instanceCache objectForKey:IRI];
    
    if (cachedInstance) {
        self = cachedInstance;
    } else {
        if ((self = [super init])) {
            _IRI = [IRI copy];
        }
        [instanceCache setObject:self forKey:_IRI];
    }
    
    return self;
}

- (void)dealloc { [instanceCache removeObjectForKey:_IRI]; }

@end
