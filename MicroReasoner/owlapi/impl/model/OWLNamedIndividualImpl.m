//
//  OWLNamedIndividualImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLNamedIndividualImpl.h"
#import "NSMapTable+SMRObjectCache.h"

@implementation OWLNamedIndividualImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object { return object == self; }

- (NSUInteger)hash { return (NSUInteger)self; }

- (NSString *)description
{
    return [NSString stringWithFormat:@"Individual(<%@>)", [_IRI absoluteString]];
}

#pragma mark OWLObject

- (NSMutableSet<id<OWLEntity>> *)signature { return [NSMutableSet setWithObject:self]; }

#pragma mark OWLNamedObject

@synthesize IRI = _IRI;

#pragma mark OWLEntity

- (OWLEntityType)entityType { return OWLEntityTypeNamedIndividual; }

- (BOOL)isOWLClass { return NO; }

- (BOOL)isOWLNamedIndividual { return YES; }

- (BOOL)isOWLObjectProperty { return NO; }

#pragma mark OWLIndividual

- (BOOL)anonymous { return NO; }

- (BOOL)named { return YES; }

- (id<OWLNamedIndividual>)asOWLNamedIndividual { return self; }

#pragma mark Other public methods

static NSMapTable *instanceCache = nil;

+ (void)initialize
{
    if (self == [OWLNamedIndividualImpl class]) {
        instanceCache = [NSMapTable smr_objCache];
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
            [instanceCache setObject:self forKey:_IRI];
        }
    }
    
    return self;
}

- (void)dealloc { [instanceCache removeObjectForKey:_IRI]; }

@end
