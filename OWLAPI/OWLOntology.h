//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
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
@protocol OWLSubClassOfAxiom;

NS_ASSUME_NONNULL_BEGIN

/// Represents an OWL 2 Ontology in the OWL 2 specification.
@protocol OWLOntology <OWLObject>

/// The identity of this ontology.
@property (nonatomic, copy, readonly) OWLOntologyID *ontologyID;

/**
 * Retrieves all of the axioms in this ontology.
 *
 * @return All the axioms in this ontology.
 */
- (NSSet<id<OWLAxiom>> *)allAxioms;

/**
 * Gets the axioms which are of the specified type.
 *
 * @param type The type of axioms to be retrieved.
 *
 * @return A set containing the axioms of the specified type.
 */
- (NSSet<id<OWLAxiom>> *)axiomsForType:(OWLAxiomType)type;

/**
 * Gets the OWLClassAssertionAxioms contained in this ontology that make the specified
 * individual an instance of some class expression.
 *
 * @param individual The individual.
 *
 * @return The set of class assertion axioms that reference the specified individual.
 */
- (NSSet<id<OWLClassAssertionAxiom>> *)classAssertionAxiomsForIndividual:(id<OWLIndividual>)individual;

/**
 * Gets the set of disjoint class axioms that contain the specified class as an operand.
 *
 * @param cls The class.
 *
 * @return The set of disjoint class axioms that contain the specified class.
 */
- (NSSet<id<OWLDisjointClassesAxiom>> *)disjointClassesAxiomsForClass:(id<OWLClass>)cls;

/**
 * Gets the set of equivalent class axioms that contain the specified class as an operand.
 *
 * @param cls The class.
 *
 * @return The set of equivalent class axioms that contain the specified class.
 */
- (NSSet<id<OWLEquivalentClassesAxiom>> *)equivalentClassesAxiomsForClass:(id<OWLClass>)cls;

/**
 * Gets all of the subclass axioms where the left hand side (the subclass)
 * is equal to the specified class.
 *
 * @param cls The class.
 *
 * @return The set of subclass axioms where the LHS is the specified class.
 */
- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls;

/**
 * Gets all of the subclass axioms where the right hand side (the superclass)
 * is equal to the specified class.
 *
 * @param cls The class.
 *
 * @return The set of subclass axioms where the RHS is the specified class.
 */
- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSuperClass:(id<OWLClass>)cls;

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
