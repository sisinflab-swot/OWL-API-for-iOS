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
#import "OWLObjectPropertyAssertionAxiom.h"
#import "OWLObjectPropertyDomainAxiom.h"
#import "OWLObjectPropertyRangeAxiom.h"
#import "OWLSubClassOfAxiom.h"

@interface OWLOntologyInternals ()
{
    NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLAxiom>> *> *_classRefs;
    NSMutableDictionary<id<OWLNamedIndividual>,NSMutableSet<id<OWLAxiom>> *> *_namedIndividualRefs;
    NSMutableDictionary<id<OWLObjectProperty>,NSMutableSet<id<OWLAxiom>> *> *_objectPropertyRefs;
    
    NSMutableDictionary<NSNumber *,NSMutableSet<id<OWLAxiom>> *> *_axiomsByType;
    NSMutableDictionary<id<OWLIndividual>,NSMutableSet<id<OWLClassAssertionAxiom>> *> *_classAssertionAxiomsByIndividual;
    NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLDisjointClassesAxiom>> *> *_disjointClassesAxiomsByClass;
    NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLEquivalentClassesAxiom>> *> *_equivalentClassesAxiomsByClass;
    NSMutableDictionary<id<OWLIndividual>,NSMutableSet<id<OWLObjectPropertyAssertionAxiom>> *> *_objectPropertyAssertionAxiomsBySubject;
    NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLSubClassOfAxiom>> *> *_subClassAxiomsBySubClass;
}

@end


@implementation OWLOntologyInternals

#pragma mark Properties

- (instancetype)init
{
    if ((self = [super init])) {
        _classRefs = [[NSMutableDictionary alloc] init];
        _namedIndividualRefs = [[NSMutableDictionary alloc] init];
        _objectPropertyRefs = [[NSMutableDictionary alloc] init];
        
        _axiomsByType = [[NSMutableDictionary alloc] init];
        _classAssertionAxiomsByIndividual = [[NSMutableDictionary alloc] init];
        _disjointClassesAxiomsByClass = [[NSMutableDictionary alloc] init];
        _equivalentClassesAxiomsByClass = [[NSMutableDictionary alloc] init];
        _objectPropertyAssertionAxiomsBySubject = [[NSMutableDictionary alloc] init];
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
        case OWLAxiomTypeClassAssertion: {
            id<OWLClassAssertionAxiom> classAssertionAxiom = (id<OWLClassAssertionAxiom>)axiom;
            id<OWLIndividual> individual = classAssertionAxiom.individual;
            
            addObjectToSetInDictionary(_classAssertionAxiomsByIndividual, individual, classAssertionAxiom);
            break;
        }
            
        case OWLAxiomTypeDisjointClasses: {
            id<OWLDisjointClassesAxiom> disjClsAxiom = (id<OWLDisjointClassesAxiom>)axiom;
            for (id<OWLClassExpression> ce in [disjClsAxiom classExpressions]) {
                if (!ce.anonymous) {
                    addObjectToSetInDictionary(_disjointClassesAxiomsByClass, ce, disjClsAxiom);
                }
            }
            break;
        }
            
        case OWLAxiomTypeEquivalentClasses: {
            id<OWLEquivalentClassesAxiom> eqClsAxiom = (id<OWLEquivalentClassesAxiom>)axiom;
            for (id<OWLClassExpression> ce in [eqClsAxiom classExpressions]) {
                if (!ce.anonymous) {
                    addObjectToSetInDictionary(_equivalentClassesAxiomsByClass, ce, eqClsAxiom);
                }
            }
            break;
        }
            
        case OWLAxiomTypeSubClassOf: {
            id<OWLSubClassOfAxiom> subClassOfAxiom = (id<OWLSubClassOfAxiom>)axiom;
            id<OWLClassExpression> subClass = subClassOfAxiom.subClass;
            
            if (!subClass.anonymous) {
                id<OWLClass> cls = [subClass asOwlClass];
                addObjectToSetInDictionary(_subClassAxiomsBySubClass, cls, subClassOfAxiom);
            }
            break;
        }
            
        case OWLAxiomTypeObjectPropertyAssertion: {
            id<OWLObjectPropertyAssertionAxiom> assertionAxiom = (id<OWLObjectPropertyAssertionAxiom>)axiom;
            id<OWLIndividual> subject = assertionAxiom.subject;
            
            addObjectToSetInDictionary(_objectPropertyAssertionAxiomsBySubject, subject, assertionAxiom);
            break;
        }
            
        default:
            break;
    }
    
    for (id<OWLEntity> entity in [axiom signature]) {
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
}

#pragma mark Public getter methods

- (NSSet<id<OWLAxiom>> *)allAxioms
{
    NSMutableSet *allAxioms = [[NSMutableSet alloc] init];
    
    [_axiomsByType enumerateKeysAndObjectsUsingBlock:^(__unused NSNumber * _Nonnull key, NSMutableSet<id<OWLAxiom>> * _Nonnull obj, __unused BOOL * _Nonnull stop) {
        [allAxioms unionSet:obj];
    }];
    
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
    return nonNilSet(_axiomsByType[@(type)]);
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

- (NSSet<id<OWLObjectPropertyAssertionAxiom>> *)objectPropertyAssertionAxiomsForIndividual:(id<OWLIndividual>)individual
{
    return nonNilSet(_objectPropertyAssertionAxiomsBySubject[individual]);
}

- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls
{
    return nonNilSet(_subClassAxiomsBySubClass[cls]);
}

@end
