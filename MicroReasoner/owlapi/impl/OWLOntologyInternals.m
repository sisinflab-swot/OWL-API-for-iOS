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

- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls
{
    NSSet *returnSet = [self.subClassAxiomsBySubClass objectForKey:cls];
    return returnSet ?: [NSSet set];
}

@end
