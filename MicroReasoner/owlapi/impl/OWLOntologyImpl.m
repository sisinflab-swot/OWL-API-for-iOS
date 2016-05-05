//
//  OWLOntologyImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntologyImpl.h"
#import "OWLOntologyID.h"
#import "OWLOntologyInternals.h"

@interface OWLOntologyImpl ()

@property (nonatomic, strong) OWLOntologyInternals *internals;

@end

@implementation OWLOntologyImpl

#pragma mark Properties

@synthesize internals = _internals;
@synthesize ontologyID = _ontologyID;

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature
{
    // TODO: finish implementing
    NSMutableSet *signature = [[NSMutableSet alloc] initWithSet:self.classesInSignature];
    return signature;
}

- (NSSet<id<OWLClass>> *)classesInSignature
{
    return [NSSet setWithArray:[self.internals.classesByIRI allValues]];
}

#pragma mark OWLOntology

- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls
{
    return [self.internals subClassAxiomsForSubClass:cls];
}

#pragma mark Other public methods

- (instancetype)initWithID:(OWLOntologyID *)ID internals:(OWLOntologyInternals *)internals
{
    NSParameterAssert(ID && internals);
    
    if ((self = [super init])) {
        _ontologyID = [ID copy];
        _internals = internals;
    }
    return self;
}

@end
