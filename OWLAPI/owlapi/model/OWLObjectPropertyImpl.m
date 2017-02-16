//
//  Created by Ivano Bilenchi on 08/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyImpl.h"
#import "OWLIRI.h"
#import "NSMapTable+SMRObjectCache.h"

@implementation OWLObjectPropertyImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object { return object == self; }

- (NSUInteger)hash { return (NSUInteger)self; }

- (NSString *)description
{
    return [NSString stringWithFormat:@"ObjectProperty(<%@>)", _IRI];
}

#pragma mark OWLObject

- (NSMutableSet<id<OWLEntity>> *)signature { return [NSMutableSet setWithObject:self]; };

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
        instanceCache = [NSMapTable smr_objCache];
    }
}

- (instancetype)initWithIRI:(OWLIRI *)IRI
{
    NSParameterAssert(IRI);
    
    id cachedInstance = [instanceCache objectForKey:IRI];
    
    if (cachedInstance) {
        self = cachedInstance;
    } else {
        if ((self = [super init])) {
            _IRI = [IRI copy];
            [instanceCache setObject:self forKey:_IRI];
        }
    }
    
    return self;
}

- (void)dealloc { [instanceCache removeObjectForKey:_IRI]; }

@end
