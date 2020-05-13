//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"
#import "OWLAxiomType.h"

@class OWLOntologyID;

@protocol OWLAnonymousIndividual;
@protocol OWLAxiom;
@protocol OWLClassAssertionAxiom;
@protocol OWLDisjointClassesAxiom;
@protocol OWLEquivalentClassesAxiom;
@protocol OWLIndividual;
@protocol OWLOntologyManager;
@protocol OWLSubClassOfAxiom;

NS_ASSUME_NONNULL_BEGIN

/// Represents an OWL 2 Ontology in the OWL 2 specification.
@protocol OWLOntology <OWLObject>

/// The identity of this ontology.
@property (nonatomic, copy, readonly) OWLOntologyID *ontologyID;

/// The manager that manages this ontology.
@property (nonatomic, strong, readonly) id<OWLOntologyManager> manager;

/**
 * Enumerates over all the axioms.
 *
 * @param handler The enumeration handler.
 */
- (void)enumerateAxiomsWithHandler:(void (^)(id<OWLAxiom> axiom))handler;

/**
 * Enumerates over the axioms having the desired types.
 *
 * @param types The desired axiom types.
 * @param handler The enumeration handler.
 */
- (void)enumerateAxiomsOfTypes:(OWLAxiomType)types
                   withHandler:(void (^)(id<OWLAxiom> axiom))handler;

/**
 * Enumerates over all the axioms of the desired types that directly or indirectly
 * reference the specified anonymous individual.
 *
 * @param individual The individual.
 * @param types The desired axiom types.
 * @param handler The enumeration handler.
 */
- (void)enumerateAxiomsReferencingAnonymousIndividual:(id<OWLAnonymousIndividual>)individual
                                              ofTypes:(OWLAxiomType)types
                                          withHandler:(void(^)(id<OWLAxiom> axiom))handler;

/**
 * Enumerates over all the axioms of the desired types that directly or indirectly
 * reference the specified class.
 *
 * @param cls The class.
 * @param types The desired axiom types.
 * @param handler The enumeration handler.
 */
- (void)enumerateAxiomsReferencingClass:(id<OWLClass>)cls
                                ofTypes:(OWLAxiomType)types
                            withHandler:(void (^)(id<OWLAxiom> axiom))handler;

/**
 * Enumerates over all the axioms of the desired types that directly or indirectly
 * reference the specified individual.
 *
 * @param individual The individual.
 * @param types The desired axiom types.
 * @param handler The enumeration handler.
 */
- (void)enumerateAxiomsReferencingIndividual:(id<OWLIndividual>)individual
                                     ofTypes:(OWLAxiomType)types
                                 withHandler:(void (^)(id<OWLAxiom> axiom))handler;

/**
 * Enumerates over all the axioms of the desired types that directly or indirectly
 * reference the specified named individual.
 *
 * @param individual The individual.
 * @param types The desired axiom types.
 * @param handler The enumeration handler.
 */
- (void)enumerateAxiomsReferencingNamedIndividual:(id<OWLNamedIndividual>)individual
                                          ofTypes:(OWLAxiomType)types
                                      withHandler:(void (^)(id<OWLAxiom> axiom))handler;

/**
 * Enumerates over all the axioms of the desired types that directly or indirectly
 * reference the specified object property.
 *
 * @param property The object property.
 * @param types The desired axiom types.
 * @param handler The enumeration handler.
 */
- (void)enumerateAxiomsReferencingObjectProperty:(id<OWLObjectProperty>)property
                                         ofTypes:(OWLAxiomType)types
                                     withHandler:(void (^)(id<OWLAxiom> axiom))handler;

@end

NS_ASSUME_NONNULL_END
