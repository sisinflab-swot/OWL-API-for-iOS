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

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        id objID = [object ontologyID];
        
        equal = (objID == _ontologyID || [objID isEqual:_ontologyID]);
    }
    
    return equal;
}

- (NSUInteger)computeHash { return _ontologyID.hash; }

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [[NSMutableSet alloc] initWithSet:self.classesInSignature];
    [signature unionSet:self.objectPropertiesInSignature];
    [signature unionSet:self.namedIndividualsInSignature];
    return signature;
}

- (NSSet<id<OWLClass>> *)classesInSignature { return [_internals allClasses]; }

- (NSSet<id<OWLNamedIndividual>> *)namedIndividualsInSignature { return [_internals allNamedIndividuals]; }

- (NSSet<id<OWLObjectProperty>> *)objectPropertiesInSignature { return [_internals allObjectProperties]; }

#pragma mark OWLOntology

- (NSSet<id<OWLAxiom>> *)axiomsForType:(OWLAxiomType)type
{
    return [_internals axiomsForType:type];
}

- (NSSet<id<OWLClassAssertionAxiom>> *)classAssertionAxiomsForIndividual:(id<OWLIndividual>)individual
{
    return [_internals classAssertionAxiomsForIndividual:individual];
}

- (NSSet<id<OWLDisjointClassesAxiom>> *)disjointClassesAxiomsForClass:(id<OWLClass>)cls
{
    return [_internals disjointClassesAxiomsForClass:cls];
}

- (NSSet<id<OWLEquivalentClassesAxiom>> *)equivalentClassesAxiomsForClass:(id<OWLClass>)cls
{
    return [_internals equivalentClassesAxiomsForClass:cls];
}

- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls
{
    return [_internals subClassAxiomsForSubClass:cls];
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
