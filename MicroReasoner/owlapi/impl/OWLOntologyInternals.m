//
//  OWLOntologyInternals.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntologyInternals.h"

@implementation OWLOntologyInternals

#pragma mark Properties

// allStatements
@synthesize allStatements = _allStatements;

- (NSMutableArray<RedlandStatement *> *)allStatements
{
    if (!_allStatements) {
        _allStatements = [[NSMutableArray alloc] init];
    }
    return _allStatements;
}

// classesByIRI
@synthesize classesByIRI = _classesByIRI;

- (NSMutableDictionary<NSURL *,id<OWLClass>> *)classesByIRI
{
    if (!_classesByIRI) {
        _classesByIRI = [[NSMutableDictionary alloc] init];
    }
    return _classesByIRI;
}

// disjointClassesAxiomsByClass
@synthesize disjointClassesAxiomsByClass = _disjointClassesAxiomsByClass;

- (NSMutableDictionary<id<OWLClass>,NSSet<id<OWLDisjointClassesAxiom>> *> *)disjointClassesAxiomsByClass
{
    if (!_disjointClassesAxiomsByClass) {
        _disjointClassesAxiomsByClass = [[NSMutableDictionary alloc] init];
    }
    return _disjointClassesAxiomsByClass;
}

// equivalentClassesAxiomeByClass
@synthesize equivalentClassesAxiomsByClass = _equivalentClassesAxiomsByClass;

- (NSMutableDictionary<id<OWLClass>,NSSet<id<OWLEquivalentClassesAxiom>> *> *)equivalentClassesAxiomsByClass
{
    if (!_equivalentClassesAxiomsByClass) {
        _equivalentClassesAxiomsByClass = [[NSMutableDictionary alloc] init];
    }
    return _equivalentClassesAxiomsByClass;
}

// subClassOfAxiomsBySubClass
@synthesize subClassAxiomsBySubClass = _subClassAxiomsBySubClass;

- (NSMutableDictionary<id<OWLClass>,NSSet<id<OWLSubClassOfAxiom>> *> *)subClassOfAxiomsBySubClass
{
    if (!_subClassAxiomsBySubClass) {
        _subClassAxiomsBySubClass = [[NSMutableDictionary alloc] init];
    }
    return _subClassAxiomsBySubClass;
}

#pragma mark Public methods

- (NSSet<id<OWLDisjointClassesAxiom>> *)disjointClassesAxiomsForClass:(id<OWLClass>)cls
{
    NSSet *returnSet = self.disjointClassesAxiomsByClass[cls];
    return returnSet ?: [NSSet set];
}

- (NSSet<id<OWLEquivalentClassesAxiom>> *)equivalentClassesAxiomsForClass:(id<OWLClass>)cls
{
    NSSet *returnSet = self.equivalentClassesAxiomsByClass[cls];
    return returnSet ?: [NSSet set];
}

- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls
{
    NSSet *returnSet = self.subClassAxiomsBySubClass[cls];
    return returnSet ?: [NSSet set];
}

@end
