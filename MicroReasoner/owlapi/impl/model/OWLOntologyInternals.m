//
//  OWLOntologyInternals.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntologyInternals.h"
#import "OWLClassExpression.h"
#import "OWLDeclarationAxiom.h"
#import "OWLEntity.h"
#import "OWLSubClassOfAxiom.h"
#import "SMRPreprocessor.h"

@interface OWLOntologyInternals ()

@property (nonatomic, strong, readonly)
NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLAxiom>> *> *axiomsByClass;

@property (nonatomic, strong, readonly)
NSMutableDictionary<id<OWLNamedIndividual>,NSMutableSet<id<OWLAxiom>> *> *axiomsByNamedIndividual;

@property (nonatomic, strong, readonly)
NSMutableDictionary<id<OWLObjectProperty>,NSMutableSet<id<OWLAxiom>> *> *axiomsByObjectProperty;

@property (nonatomic, strong, readonly)
NSMutableDictionary<NSNumber *,NSMutableSet<id<OWLAxiom>> *> *axiomsByType;

@property (nonatomic, strong, readonly)
NSMutableDictionary<id<OWLIndividual>,NSMutableSet<id<OWLClassAssertionAxiom>> *> *classAssertionAxiomsByIndividual;

@property (nonatomic, strong, readonly)
NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLDisjointClassesAxiom>> *> *disjointClassesAxiomsByClass;

@property (nonatomic, strong, readonly)
NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLEquivalentClassesAxiom>> *> *equivalentClassesAxiomsByClass;

@property (nonatomic, strong, readonly)
NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLSubClassOfAxiom>> *> *subClassAxiomsBySubClass;

@end


@implementation OWLOntologyInternals

#pragma mark Properties

SYNTHESIZE_LAZY_INIT(NSMutableDictionary, axiomsByClass);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, axiomsByObjectProperty);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, axiomsByNamedIndividual);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, axiomsByType);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, classAssertionAxiomsByIndividual);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, disjointClassesAxiomsByClass);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, equivalentClassesAxiomsByClass);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, subClassAxiomsBySubClass);

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
    addObjectToSetInDictionary(self.axiomsByType, [NSNumber numberWithInteger:type], axiom);
    
    switch (type) {
            
        case OWLAxiomTypeDeclaration: {
            id<OWLEntity> declaredEntity = [(id<OWLDeclarationAxiom>)axiom entity];
            [self _addAxiom:axiom forEntity:declaredEntity];
            break;
        }
            
        case OWLAxiomTypeSubClassOf: {
            id<OWLSubClassOfAxiom> subClassOfAxiom = (id<OWLSubClassOfAxiom>)axiom;
            id<OWLClassExpression> subClass = subClassOfAxiom.subClass;
            id<OWLClassExpression> superClass = subClassOfAxiom.superClass;
            
            if (!subClass.anonymous) {
                id<OWLClass> cls = [subClass asOwlClass];
                addObjectToSetInDictionary(self.axiomsByClass, cls, subClassOfAxiom);
                addObjectToSetInDictionary(self.subClassAxiomsBySubClass, cls, subClassOfAxiom);
            }
            
            if (!superClass.anonymous) {
                id<OWLClass> cls = [superClass asOwlClass];
                addObjectToSetInDictionary(self.axiomsByClass, cls, subClassOfAxiom);
            }
        }
            
        default:
            break;
    }
}

#pragma mark Public getter methods

- (NSSet<id<OWLClass>> *)allClasses
{
    return [NSSet setWithArray:[self.axiomsByClass allKeys]];
}

- (NSSet<id<OWLObjectProperty>> *)allObjectProperties
{
    return [NSSet setWithArray:[self.axiomsByObjectProperty allKeys]];
}

- (NSSet<id<OWLNamedIndividual>> *)allNamedIndividuals
{
    return [NSSet setWithArray:[self.axiomsByNamedIndividual allKeys]];
}

- (NSSet<id<OWLClassAssertionAxiom>> *)classAssertionAxiomsForIndividual:(id<OWLIndividual>)individual
{
    return nonNilSet(self.classAssertionAxiomsByIndividual[individual]);
}

- (NSSet<id<OWLDisjointClassesAxiom>> *)disjointClassesAxiomsForClass:(id<OWLClass>)cls
{
    return nonNilSet(self.disjointClassesAxiomsByClass[cls]);
}

- (NSSet<id<OWLEquivalentClassesAxiom>> *)equivalentClassesAxiomsForClass:(id<OWLClass>)cls
{
    return nonNilSet(self.equivalentClassesAxiomsByClass[cls]);
}

- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls
{
    return nonNilSet(self.subClassAxiomsBySubClass[cls]);
}

#pragma mark Private methods

- (void)_addAxiom:(id<OWLAxiom>)axiom forEntity:(id<OWLEntity>)entity
{
    switch (entity.entityType) {
        case OWLEntityTypeClass:
            addObjectToSetInDictionary(self.axiomsByClass, entity, axiom);
            break;
            
        case OWLEntityTypeNamedIndividual:
            addObjectToSetInDictionary(self.axiomsByNamedIndividual, entity, axiom);
            break;
            
        case OWLEntityTypeObjectProperty:
            addObjectToSetInDictionary(self.axiomsByObjectProperty, entity, axiom);
            break;
            
        default:
            break;
    }
}

@end
