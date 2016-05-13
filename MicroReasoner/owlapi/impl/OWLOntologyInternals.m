//
//  OWLOntologyInternals.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntologyInternals.h"
#import "SMRPreprocessor.h"

@interface OWLOntologyInternals ()

@property (nonatomic, strong, readonly) NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLAxiom>> *> *axiomsByClass;
@property (nonatomic, strong, readonly) NSMutableDictionary<id<OWLObjectProperty>,NSMutableSet<id<OWLAxiom>> *> *axiomsByObjectProperty;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSNumber *,NSMutableSet<id<OWLAxiom>> *> *axiomsByType;

@property (nonatomic, strong, readonly)
NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLDisjointClassesAxiom>> *> *disjointClassesAxiomsByClass;

@property (nonatomic, strong, readonly)
NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLEquivalentClassesAxiom>> *> *equivalentClassesAxiomsByClass;

@property (nonatomic, strong, readonly)
NSMutableDictionary<id<OWLClass>,NSMutableSet<id<OWLSubClassOfAxiom>> *> *subClassAxiomsBySubClass;

@end


@implementation OWLOntologyInternals

#pragma mark Properties

SYNTHESIZE_LAZY_INIT(NSMutableArray, allStatements); // TODO: remove
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, axiomsByClass);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, axiomsByObjectProperty);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, axiomsByType);
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

- (void)addAxiom:(id<OWLAxiom>)axiom ofType:(OWLAxiomType)type
{
    addObjectToSetInDictionary(self.axiomsByType, [NSNumber numberWithInteger:type], axiom);
}

- (void)addAxiom:(id<OWLAxiom>)axiom forClass:(id<OWLClass>)cls
{
    addObjectToSetInDictionary(self.axiomsByClass, cls, axiom);
}

- (void)addAxiom:(id<OWLAxiom>)axiom forObjectProperty:(id<OWLObjectProperty>)property
{
    addObjectToSetInDictionary(self.axiomsByObjectProperty, property, axiom);
}

#pragma mark Public getter methods

- (NSSet<id<OWLClass>> *)allClasses { return [NSSet setWithArray:[self.axiomsByClass allKeys]]; }
- (NSSet<id<OWLObjectProperty>> *)allObjectProperties { return [NSSet setWithArray:[self.axiomsByObjectProperty allKeys]]; }

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

@end
