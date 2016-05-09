//
//  OWLClassImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClassImpl.h"
#import "OWLDisjointClassesAxiom.h"
#import "OWLEquivalentClassesAxiom.h"
#import "OWLOntology.h"
#import "OWLSubClassOfAxiom.h"

@implementation OWLClassImpl

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

- (NSUInteger)hash { return [self.IRI hash]; }

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

- (NSSet<id<OWLClassExpression>> *)asConjunctSet { return [NSSet setWithObject:self]; }

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

- (NSSet<id<OWLClassExpression>> *)equivalentClassesInOntology:(id<OWLOntology>)ontology
{
    NSMutableSet *equivalentClasses = [[NSMutableSet alloc] init];
    
    for (id<OWLEquivalentClassesAxiom> axiom in [ontology equivalentClassesAxiomsForClass:self]) {
        [equivalentClasses unionSet:axiom.classExpressions];
    }
    
    return equivalentClasses;
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
