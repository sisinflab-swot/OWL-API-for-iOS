//
//  OWLClassImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClassImpl.h"

@implementation OWLClassImpl

#pragma mark Properties

@synthesize IRI = _IRI;

#pragma mark Public methods

- (instancetype)initWithIRI:(NSURL *)IRI
{
    if ((self = [super init])) {
        _IRI = [IRI copy];
    }
    return self;
}

- (BOOL)anonymous
{
    return NO;
}

- (id<OWLClass>)asOwlClass
{
    return self;
}

- (NSSet<id<OWLClass>> *)getClassesInSignature
{
    return [NSSet setWithObject:self];
}

- (NSSet<id<OWLClassExpression>> *)getSuperClassesInOntology:(id<OWLOntology>)ontology
{
    // TODO: implement
    NSParameterAssert(ontology);
    return [NSSet set];
}

- (NSString *)description
{
    return [self.IRI absoluteString];
}

@end
