//
//  OWLOntology.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"
#import "OWLAxiomType.h"

@class OWLOntologyID;

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

@end

NS_ASSUME_NONNULL_END
