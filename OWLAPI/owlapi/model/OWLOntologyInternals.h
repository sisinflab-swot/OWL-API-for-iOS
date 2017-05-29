//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OWLAxiomType.h"

@protocol OWLAnonymousIndividual;
@protocol OWLAxiom;
@protocol OWLClass;
@protocol OWLClassAssertionAxiom;
@protocol OWLClassExpression;
@protocol OWLDisjointClassesAxiom;
@protocol OWLEquivalentClassesAxiom;
@protocol OWLIndividual;
@protocol OWLNamedIndividual;
@protocol OWLObjectProperty;
@protocol OWLObjectPropertyAssertionAxiom;
@protocol OWLSubClassOfAxiom;

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyInternals : NSObject

#pragma mark Mutation methods

- (void)addAxiom:(id<OWLAxiom>)axiom;

#pragma mark Enumeration methods

- (void)enumerateAxiomsReferencingAnonymousIndividual:(id<OWLAnonymousIndividual>)individual
                                              ofTypes:(OWLAxiomType)types
                                          withHandler:(void(^)(id<OWLAxiom> axiom))handler;

- (void)enumerateAxiomsReferencingClass:(id<OWLClass>)cls
                                ofTypes:(OWLAxiomType)types
                            withHandler:(void (^)(id<OWLAxiom> axiom))handler;

- (void)enumerateAxiomsReferencingIndividual:(id<OWLIndividual>)individual
                                     ofTypes:(OWLAxiomType)types
                                 withHandler:(void (^)(id<OWLAxiom> axiom))handler;

- (void)enumerateAxiomsReferencingNamedIndividual:(id<OWLNamedIndividual>)individual
                                          ofTypes:(OWLAxiomType)types
                                      withHandler:(void (^)(id<OWLAxiom> axiom))handler;

- (void)enumerateAxiomsReferencingObjectProperty:(id<OWLObjectProperty>)property
                                         ofTypes:(OWLAxiomType)types
                                     withHandler:(void (^)(id<OWLAxiom> axiom))handler;

#pragma mark Getter methods

- (NSSet<id<OWLAxiom>> *)allAxioms;
- (NSSet<id<OWLClass>> *)allClasses;
- (NSSet<id<OWLNamedIndividual>> *)allNamedIndividuals;
- (NSSet<id<OWLObjectProperty>> *)allObjectProperties;

- (NSSet<id<OWLAxiom>> *)axiomsForType:(OWLAxiomType)type;
- (NSSet<id<OWLClassAssertionAxiom>> *)classAssertionAxiomsForIndividual:(id<OWLIndividual>)individual;
- (NSSet<id<OWLDisjointClassesAxiom>> *)disjointClassesAxiomsForClass:(id<OWLClass>)cls;
- (NSSet<id<OWLEquivalentClassesAxiom>> *)equivalentClassesAxiomsForClass:(id<OWLClass>)cls;
- (NSSet<id<OWLObjectPropertyAssertionAxiom>> *)objectPropertyAssertionAxiomsForIndividual:(id<OWLIndividual>)individual;
- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls;
- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSuperClass:(id<OWLClass>)cls;

@end

NS_ASSUME_NONNULL_END
