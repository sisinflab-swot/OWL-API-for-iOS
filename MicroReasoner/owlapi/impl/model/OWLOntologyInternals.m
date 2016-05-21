//
//  OWLOntologyInternals.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntologyInternals.h"
#import "OWLClassAssertionAxiom.h"
#import "OWLClassExpression.h"
#import "OWLDeclarationAxiom.h"
#import "OWLDisjointClassesAxiom.h"
#import "OWLEntity.h"
#import "OWLEquivalentClassesAxiom.h"
#import "OWLIndividual.h"
#import "OWLObjectPropertyDomainAxiom.h"
#import "OWLObjectPropertyRangeAxiom.h"
#import "OWLSubClassOfAxiom.h"
#import "SMRPreprocessor.h"

@interface OWLOntologyInternals ()
{
    NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLAxiom>> *> *_axiomsByClass;
    NSMutableDictionary<id<OWLNamedIndividual>,NSMutableSet<id<OWLAxiom>> *> *_axiomsByNamedIndividual;
    NSMutableDictionary<id<OWLObjectProperty>,NSMutableSet<id<OWLAxiom>> *> *_axiomsByObjectProperty;
    NSMutableDictionary<NSNumber *,NSMutableSet<id<OWLAxiom>> *> *_axiomsByType;
    NSMutableDictionary<id<OWLIndividual>,NSMutableSet<id<OWLClassAssertionAxiom>> *> *_classAssertionAxiomsByIndividual;
    NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLDisjointClassesAxiom>> *> *_disjointClassesAxiomsByClass;
    NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLEquivalentClassesAxiom>> *> *_equivalentClassesAxiomsByClass;
    NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLSubClassOfAxiom>> *> *_subClassAxiomsBySubClass;
}

@end


@implementation OWLOntologyInternals

#pragma mark Properties

- (instancetype)init
{
    if ((self = [super init])) {
        _axiomsByClass = [[NSMutableDictionary alloc] init];
        _axiomsByNamedIndividual = [[NSMutableDictionary alloc] init];
        _axiomsByObjectProperty = [[NSMutableDictionary alloc] init];
        _axiomsByType = [[NSMutableDictionary alloc] init];
        _classAssertionAxiomsByIndividual = [[NSMutableDictionary alloc] init];
        _disjointClassesAxiomsByClass = [[NSMutableDictionary alloc] init];
        _equivalentClassesAxiomsByClass = [[NSMutableDictionary alloc] init];
        _subClassAxiomsBySubClass = [[NSMutableDictionary alloc] init];
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
    addObjectToSetInDictionary(_axiomsByType, [NSNumber numberWithInteger:type], axiom);
    
    switch (type)
    {
        case OWLAxiomTypeDeclaration: {
            id<OWLEntity> declaredEntity = [(id<OWLDeclarationAxiom>)axiom entity];
            [self _addAxiom:axiom forEntity:declaredEntity];
            break;
        }
            
        case OWLAxiomTypeClassAssertion: {
            id<OWLClassAssertionAxiom> classAssertionAxiom = (id<OWLClassAssertionAxiom>)axiom;
            id<OWLIndividual> individual = classAssertionAxiom.individual;
            
            addObjectToSetInDictionary(_classAssertionAxiomsByIndividual, individual, classAssertionAxiom);
            
            if (!individual.anonymous) {
                addObjectToSetInDictionary(_axiomsByNamedIndividual, individual, classAssertionAxiom);
            }
            
            id<OWLClassExpression> ce = classAssertionAxiom.classExpression;
            if (!ce.anonymous) {
                addObjectToSetInDictionary(_axiomsByClass, ce, classAssertionAxiom);
            }
            
            break;
        }
            
        case OWLAxiomTypeDisjointClasses: {
            id<OWLDisjointClassesAxiom> disjClsAxiom = (id<OWLDisjointClassesAxiom>)axiom;
            for (id<OWLClassExpression> ce in [disjClsAxiom classExpressions]) {
                if (!ce.anonymous) {
                    addObjectToSetInDictionary(_axiomsByClass, ce, disjClsAxiom);
                    addObjectToSetInDictionary(_disjointClassesAxiomsByClass, ce, disjClsAxiom);
                }
            }
            break;
        }
            
        case OWLAxiomTypeEquivalentClasses: {
            id<OWLEquivalentClassesAxiom> eqClsAxiom = (id<OWLEquivalentClassesAxiom>)axiom;
            for (id<OWLClassExpression> ce in [eqClsAxiom classExpressions]) {
                if (!ce.anonymous) {
                    addObjectToSetInDictionary(_axiomsByClass, ce, eqClsAxiom);
                    addObjectToSetInDictionary(_equivalentClassesAxiomsByClass, ce, eqClsAxiom);
                }
            }
            break;
        }
            
        case OWLAxiomTypeSubClassOf: {
            id<OWLSubClassOfAxiom> subClassOfAxiom = (id<OWLSubClassOfAxiom>)axiom;
            id<OWLClassExpression> subClass = subClassOfAxiom.subClass;
            id<OWLClassExpression> superClass = subClassOfAxiom.superClass;
            
            if (!subClass.anonymous) {
                id<OWLClass> cls = [subClass asOwlClass];
                addObjectToSetInDictionary(_axiomsByClass, cls, subClassOfAxiom);
                addObjectToSetInDictionary(_subClassAxiomsBySubClass, cls, subClassOfAxiom);
            }
            
            if (!superClass.anonymous) {
                id<OWLClass> cls = [superClass asOwlClass];
                addObjectToSetInDictionary(_axiomsByClass, cls, subClassOfAxiom);
            }
            break;
        }
            
        case OWLAxiomTypeObjectPropertyDomain: {
            id<OWLObjectPropertyDomainAxiom> domainAxiom = (id<OWLObjectPropertyDomainAxiom>)axiom;
            
            id<OWLObjectProperty> objectProperty = [domainAxiom.property asOWLObjectProperty];
            if (objectProperty) {
                addObjectToSetInDictionary(_axiomsByObjectProperty, objectProperty, domainAxiom);
            }
            
            id<OWLClassExpression> ce = domainAxiom.domain;
            if (!ce.anonymous) {
                addObjectToSetInDictionary(_axiomsByClass, ce, domainAxiom);
            }
            
            break;
        }
            
        case OWLAxiomTypeObjectPropertyRange: {
            id<OWLObjectPropertyRangeAxiom> rangeAxiom = (id<OWLObjectPropertyRangeAxiom>)axiom;
            
            id<OWLObjectProperty> objectProperty = [rangeAxiom.property asOWLObjectProperty];
            if (objectProperty) {
                addObjectToSetInDictionary(_axiomsByObjectProperty, objectProperty, rangeAxiom);
            }
            
            id<OWLClassExpression> ce = rangeAxiom.range;
            if (!ce.anonymous) {
                addObjectToSetInDictionary(_axiomsByClass, ce, rangeAxiom);
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark Public getter methods

- (NSSet<id<OWLClass>> *)allClasses
{
    return [NSSet setWithArray:[_axiomsByClass allKeys]];
}

- (NSSet<id<OWLObjectProperty>> *)allObjectProperties
{
    return [NSSet setWithArray:[_axiomsByObjectProperty allKeys]];
}

- (NSSet<id<OWLNamedIndividual>> *)allNamedIndividuals
{
    return [NSSet setWithArray:[_axiomsByNamedIndividual allKeys]];
}

- (NSSet<id<OWLClassAssertionAxiom>> *)classAssertionAxiomsForIndividual:(id<OWLIndividual>)individual
{
    return nonNilSet(_classAssertionAxiomsByIndividual[individual]);
}

- (NSSet<id<OWLDisjointClassesAxiom>> *)disjointClassesAxiomsForClass:(id<OWLClass>)cls
{
    return nonNilSet(_disjointClassesAxiomsByClass[cls]);
}

- (NSSet<id<OWLEquivalentClassesAxiom>> *)equivalentClassesAxiomsForClass:(id<OWLClass>)cls
{
    return nonNilSet(_equivalentClassesAxiomsByClass[cls]);
}

- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls
{
    return nonNilSet(_subClassAxiomsBySubClass[cls]);
}

#pragma mark Private methods

- (void)_addAxiom:(id<OWLAxiom>)axiom forEntity:(id<OWLEntity>)entity
{
    switch (entity.entityType) {
        case OWLEntityTypeClass:
            addObjectToSetInDictionary(_axiomsByClass, entity, axiom);
            break;
            
        case OWLEntityTypeNamedIndividual:
            addObjectToSetInDictionary(_axiomsByNamedIndividual, entity, axiom);
            break;
            
        case OWLEntityTypeObjectProperty:
            addObjectToSetInDictionary(_axiomsByObjectProperty, entity, axiom);
            break;
            
        default:
            break;
    }
}

@end
