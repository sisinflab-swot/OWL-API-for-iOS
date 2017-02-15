//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClassImpl.h"
#import "OWLDisjointClassesAxiom.h"
#import "OWLEquivalentClassesAxiom.h"
#import "OWLOntology.h"
#import "OWLRDFVocabulary.h"
#import "OWLSubClassOfAxiom.h"
#import "NSMapTable+SMRObjectCache.h"

@implementation OWLClassImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object { return object == self; }

- (NSUInteger)hash { return (NSUInteger)self; }

- (NSString *)description
{
    return [NSString stringWithFormat:@"Class(<%@>)", [_IRI absoluteString]];
}

#pragma mark OWLObject

- (NSMutableSet<id<OWLEntity>> *)signature { return [NSMutableSet setWithObject:self]; }

#pragma mark OWLNamedObject

@synthesize IRI = _IRI;

#pragma mark OWLEntity

- (OWLEntityType)entityType { return OWLEntityTypeClass; }

- (BOOL)isOWLClass { return YES; }

- (BOOL)isOWLNamedIndividual { return NO; }

- (BOOL)isOWLObjectProperty { return NO; }

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType { return OWLClassExpTypeClass; }

- (BOOL)anonymous { return NO; }

- (BOOL)isOWLThing { return [_IRI isEqual:[OWLRDFVocabulary OWLThing].IRI]; }

- (BOOL)isOWLNothing { return [_IRI isEqual:[OWLRDFVocabulary OWLNothing].IRI]; }

- (NSSet<id<OWLClassExpression>> *)asConjunctSet { return [NSSet setWithObject:self]; }

- (id<OWLClass>)asOwlClass { return self; }

#pragma mark OWLClass

- (NSSet<id<OWLClassExpression>> *)disjointClassesInOntology:(id<OWLOntology>)ontology
{
    NSMutableSet *disjointClasses = [[NSMutableSet alloc] init];
    
    for (id<OWLDisjointClassesAxiom> axiom in [ontology disjointClassesAxiomsForClass:self]) {
        [disjointClasses unionSet:axiom.classExpressions];
    }
    
    [disjointClasses removeObject:self];
    
    return disjointClasses;
}

- (NSSet<id<OWLClassExpression>> *)equivalentClassesInOntology:(id<OWLOntology>)ontology
{
    NSMutableSet *equivalentClasses = [[NSMutableSet alloc] init];
    
    for (id<OWLEquivalentClassesAxiom> axiom in [ontology equivalentClassesAxiomsForClass:self]) {
        [equivalentClasses unionSet:axiom.classExpressions];
    }
    
    [equivalentClasses removeObject:self];
    
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

static NSMapTable *instanceCache = nil;

+ (void)initialize
{
    if (self == [OWLClassImpl class]) {
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
