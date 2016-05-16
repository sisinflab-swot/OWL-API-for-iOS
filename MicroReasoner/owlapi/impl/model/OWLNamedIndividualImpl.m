//
//  OWLNamedIndividualImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLNamedIndividualImpl.h"

@implementation OWLNamedIndividualImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        NSURL *objIRI = [object IRI];
        NSURL *selfIRI = self.IRI;
        
        equal = (objIRI == selfIRI || [objIRI isEqual:selfIRI]);
    }
    
    return equal;
}

- (NSUInteger)hash { return self.IRI.hash; }

- (NSString *)description
{
    return [NSString stringWithFormat:@"Individual(<%@>)", [self.IRI absoluteString]];
}

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature { return [NSSet setWithObject:self]; }

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

- (instancetype)initWithIRI:(NSURL *)IRI
{
    NSParameterAssert(IRI);
    
    if ((self = [super init])) {
        _IRI = [IRI copy];
    }
    
    return self;
}

@end
