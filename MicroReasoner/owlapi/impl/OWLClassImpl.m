//
//  OWLClassImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClassImpl.h"
#import "OWLDisjointClassesAxiom.h"
#import "OWLOntology.h"
#import "OWLSubClassOfAxiom.h"

@implementation OWLClassImpl

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature { return [NSSet setWithObject:self]; }

#pragma mark OWLNamedObject

@synthesize IRI = _IRI;

#pragma mark OWLEntity

- (BOOL)isOWLClass { return YES; }

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType { return OWLClassExpTypeClass; }

- (BOOL)anonymous { return NO; }

- (BOOL)isOWLThing
{
    // TODO: implement
    return NO;
}

- (BOOL)isOWLNothing
{
    // TODO: implement
    return NO;
}

- (id<OWLClass>)asOwlClass { return self; }

#pragma mark OWLClass

- (NSSet<id<OWLClassExpression>> *)disjointClassesInOntology:(id<OWLOntology>)ontology
{
    NSMutableSet *disjointClasses = [[NSMutableSet alloc] init];
    
    for (id<OWLDisjointClassesAxiom> axiom in [ontology disjointClassesAxiomsForClass:self]) {
        [disjointClasses unionSet:axiom.classExpressions];
    }
    
    return disjointClasses;
}

- (NSSet<id<OWLClassExpression>> *)superClassesInOntology:(id<OWLOntology>)ontology
{
    NSMutableSet *superClasses = [[NSMutableSet alloc] init];
    
    for (id<OWLSubClassOfAxiom> axiom in [ontology subClassAxiomsForSubClass:self]) {
        [superClasses addObject:axiom.superClass];
    }
    
    return superClasses;
}

#pragma mark Other public methods

- (instancetype)initWithIRI:(NSURL *)IRI
{
    if ((self = [super init])) {
        _IRI = [IRI copy];
    }
    return self;
}

- (NSString *)description { return [self.IRI absoluteString]; }

@end
