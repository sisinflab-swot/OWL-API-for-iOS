//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntologyInternals.h"
#import "OWLAnonymousIndividual.h"
#import "OWLClassAssertionAxiom.h"
#import "OWLClassExpression.h"
#import "OWLDeclarationAxiom.h"
#import "OWLDisjointClassesAxiom.h"
#import "OWLEntity.h"
#import "OWLEquivalentClassesAxiom.h"
#import "OWLIndividual.h"
#import "OWLObjectPropertyAssertionAxiom.h"
#import "OWLObjectPropertyDomainAxiom.h"
#import "OWLObjectPropertyRangeAxiom.h"
#import "OWLSubClassOfAxiom.h"
#import "OWLTransitiveObjectPropertyAxiom.h"

@interface OWLOntologyInternals ()
{
    NSArray<NSMutableSet<id<OWLAxiom>> *> *_axiomsByType;
    
    NSMutableDictionary<id<OWLAnonymousIndividual>,NSMutableSet<id<OWLAxiom>> *> *_anonymousIndividualRefs;
    NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLAxiom>> *> *_classRefs;
    NSMutableDictionary<id<OWLNamedIndividual>,NSMutableSet<id<OWLAxiom>> *> *_namedIndividualRefs;
    NSMutableDictionary<id<OWLObjectProperty>,NSMutableSet<id<OWLAxiom>> *> *_objectPropertyRefs;
}

@end


@implementation OWLOntologyInternals

#pragma mark Properties

- (instancetype)init
{
    if ((self = [super init])) {
        NSMutableArray *axiomsByType = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < OWLAxiomTypeCount; i++) {
            [axiomsByType addObject:[NSMutableSet set]];
        }
        
        _axiomsByType = axiomsByType;
        
        _anonymousIndividualRefs = [[NSMutableDictionary alloc] init];
        _classRefs = [[NSMutableDictionary alloc] init];
        _namedIndividualRefs = [[NSMutableDictionary alloc] init];
        _objectPropertyRefs = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark Public mutation methods

NS_INLINE void addObjectToSetInDictionary(NSMutableDictionary *dict, id key, id obj) {
    
    NSMutableSet *objectsForKey = dict[key];
    
    if (objectsForKey) {
        [objectsForKey addObject:obj];
    } else {
        objectsForKey = [NSMutableSet setWithObject:obj];
        dict[key] = objectsForKey;
    }
}

NS_INLINE NSSet * nonNilSet(NSSet *set) {
    return set ? [set copy] : [[NSSet alloc] init];
}

- (void)addAxiom:(id<OWLAxiom>)axiom
{
    OWLAxiomType type = axiom.axiomType;
    [_axiomsByType[type] addObject:axiom];
    
    switch (type)
    {
        case OWLAxiomTypeClassAssertion: {
            id<OWLClassAssertionAxiom> classAssertionAxiom = (id<OWLClassAssertionAxiom>)axiom;
            [self addAxiom:axiom forIndividual:classAssertionAxiom.individual];
            [self addAxiom:axiom forClassExpression:classAssertionAxiom.classExpression];
            
            break;
        }
            
        case OWLAxiomTypeDeclaration: {
            id<OWLDeclarationAxiom> declarationAxiom = (id<OWLDeclarationAxiom>)axiom;
            [self addAxiom:axiom forEntity:declarationAxiom.entity];
            
            break;
        }
            
        case OWLAxiomTypeDisjointClasses: {
            id<OWLDisjointClassesAxiom> disjointAxiom = (id<OWLDisjointClassesAxiom>)axiom;
            for (id<OWLClassExpression> ce in disjointAxiom.classExpressions) {
                [self addAxiom:axiom forClassExpression:ce];
            }
            
            break;
        }
            
        case OWLAxiomTypeEquivalentClasses: {
            id<OWLEquivalentClassesAxiom> equivalentAxiom = (id<OWLEquivalentClassesAxiom>)axiom;
            for (id<OWLClassExpression> ce in equivalentAxiom.classExpressions) {
                [self addAxiom:axiom forClassExpression:ce];
            }
            
            break;
        }
            
        case OWLAxiomTypeObjectPropertyAssertion: {
            id<OWLObjectPropertyAssertionAxiom> assertionAxiom = (id<OWLObjectPropertyAssertionAxiom>)axiom;
            [self addAxiom:axiom forIndividual:assertionAxiom.subject];
            [self addAxiom:axiom forIndividual:assertionAxiom.object];
            [self addAxiom:axiom forPropertyExpression:assertionAxiom.property];
            
            break;
        }
            
        case OWLAxiomTypeObjectPropertyDomain: {
            id<OWLObjectPropertyDomainAxiom> domainAxiom = (id<OWLObjectPropertyDomainAxiom>)axiom;
            [self addAxiom:axiom forPropertyExpression:domainAxiom.property];
            [self addAxiom:axiom forClassExpression:domainAxiom.domain];
            
            break;
        }
            
        case OWLAxiomTypeObjectPropertyRange: {
            id<OWLObjectPropertyRangeAxiom> rangeAxiom = (id<OWLObjectPropertyRangeAxiom>)axiom;
            [self addAxiom:axiom forPropertyExpression:rangeAxiom.property];
            [self addAxiom:axiom forClassExpression:rangeAxiom.range];
            
            break;
        }
            
        case OWLAxiomTypeSubClassOf: {
            id<OWLSubClassOfAxiom> subAxiom = (id<OWLSubClassOfAxiom>)axiom;
            [self addAxiom:axiom forClassExpression:subAxiom.superClass];
            [self addAxiom:axiom forClassExpression:subAxiom.subClass];
            
            break;
        }
            
        case OWLAxiomTypeTransitiveObjectProperty: {
            id<OWLTransitiveObjectPropertyAxiom> transitiveAxiom = (id<OWLTransitiveObjectPropertyAxiom>)axiom;
            [self addAxiom:axiom forPropertyExpression:transitiveAxiom.property];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)addAxiom:(id<OWLAxiom>)axiom forClassExpression:(id<OWLClassExpression>)expression
{
    if (expression.anonymous)
    {
        // Class expression.
        for (id<OWLEntity> entity in [expression signature]) {
            [self addAxiom:axiom forEntity:entity];
        }
    } else {
        // Named class.
        addObjectToSetInDictionary(_classRefs, expression, axiom);
    }
}

- (void)addAxiom:(id<OWLAxiom>)axiom forEntity:(id<OWLEntity>)entity
{
    switch (entity.entityType) {
        case OWLEntityTypeClass:
            addObjectToSetInDictionary(_classRefs, entity, axiom);
            break;
            
        case OWLEntityTypeObjectProperty:
            addObjectToSetInDictionary(_objectPropertyRefs, entity, axiom);
            break;
            
        case OWLEntityTypeNamedIndividual:
            addObjectToSetInDictionary(_namedIndividualRefs, entity, axiom);
            break;
            
        default:
            break;
    }
}

- (void)addAxiom:(id<OWLAxiom>)axiom forIndividual:(id<OWLIndividual>)individual
{
    NSMutableDictionary *refs = individual.anonymous ? (id)_anonymousIndividualRefs : (id)_namedIndividualRefs;
    addObjectToSetInDictionary(refs, individual, axiom);
}

- (void)addAxiom:(id<OWLAxiom>)axiom forPropertyExpression:(id<OWLPropertyExpression>)expression
{
    // TODO: only supports named properties.
    if (!expression.anonymous) {
        addObjectToSetInDictionary(_objectPropertyRefs, expression, axiom);
    }
}

#pragma mark Public getter methods

- (NSSet<id<OWLAnonymousIndividual>> *)allAnonymousIndividuals
{
    return [NSSet setWithArray:[_anonymousIndividualRefs allKeys]];
}

- (NSSet<id<OWLAxiom>> *)allAxioms
{
    NSMutableSet *allAxioms = [[NSMutableSet alloc] init];
    
    for (NSSet<id<OWLAxiom>> *axioms in _axiomsByType) {
        [allAxioms unionSet:axioms];
    }
    
    return allAxioms;
}

- (NSSet<id<OWLClass>> *)allClasses
{
    return [NSSet setWithArray:[_classRefs allKeys]];
}

- (NSSet<id<OWLObjectProperty>> *)allObjectProperties
{
    return [NSSet setWithArray:[_objectPropertyRefs allKeys]];
}

- (NSSet<id<OWLNamedIndividual>> *)allNamedIndividuals
{
    return [NSSet setWithArray:[_namedIndividualRefs allKeys]];
}

- (NSSet<id<OWLAxiom>> *)axiomsForType:(OWLAxiomType)type
{
    return nonNilSet(_axiomsByType[type]);
}

- (NSSet<id<OWLClassAssertionAxiom>> *)classAssertionAxiomsForIndividual:(id<OWLIndividual>)individual
{
    NSMutableSet *axioms = [[NSMutableSet alloc] init];
    NSDictionary *refs = individual.anonymous ? (id)_anonymousIndividualRefs : (id)_namedIndividualRefs;
    
    for (id<OWLClassAssertionAxiom> axiom in refs[individual]) {
        if (axiom.axiomType == OWLAxiomTypeClassAssertion) {
            [axioms addObject:axiom];
        }
    }
    
    return axioms;
}

- (NSSet<id<OWLDisjointClassesAxiom>> *)disjointClassesAxiomsForClass:(id<OWLClass>)cls
{
    NSMutableSet *axioms = [[NSMutableSet alloc] init];
    
    for (id<OWLDisjointClassesAxiom> axiom in _classRefs[cls]) {
        if (axiom.axiomType == OWLAxiomTypeDisjointClasses && [(NSSet *)axiom.classExpressions containsObject:cls]) {
            [axioms addObject:axiom];
        }
    }
    
    return axioms;
}

- (NSSet<id<OWLEquivalentClassesAxiom>> *)equivalentClassesAxiomsForClass:(id<OWLClass>)cls
{
    NSMutableSet *axioms = [[NSMutableSet alloc] init];
    
    for (id<OWLEquivalentClassesAxiom> axiom in _classRefs[cls]) {
        if (axiom.axiomType == OWLAxiomTypeEquivalentClasses && [(NSSet *)axiom.classExpressions containsObject:cls]) {
            [axioms addObject:axiom];
        }
    }
    
    return axioms;
}

- (NSSet<id<OWLObjectPropertyAssertionAxiom>> *)objectPropertyAssertionAxiomsForIndividual:(id<OWLIndividual>)individual
{
    NSMutableSet *axioms = [[NSMutableSet alloc] init];
    NSDictionary *refs = individual.anonymous ? (NSDictionary *)_anonymousIndividualRefs : (NSDictionary *)_namedIndividualRefs;
    
    for (id<OWLObjectPropertyAssertionAxiom> axiom in refs[individual]) {
        if (axiom.axiomType == OWLAxiomTypeObjectPropertyAssertion) {
            [axioms addObject:axiom];
        }
    }
    
    return axioms;
}

- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls
{
    NSMutableSet *axioms = [[NSMutableSet alloc] init];
    
    for (id<OWLSubClassOfAxiom> axiom in _classRefs[cls]) {
        if (axiom.axiomType == OWLAxiomTypeSubClassOf && (id<OWLClass>)axiom.subClass == cls) {
            [axioms addObject:axiom];
        }
    }
    
    return axioms;
}

@end
