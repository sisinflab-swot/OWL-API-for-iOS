//
//  Created by Ivano Bilenchi on 29/05/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import "OWLEntityType.h"
#import "OWLNodeID.h"

@protocol OWLAnonymousIndividual;
@protocol OWLClass;
@protocol OWLClassAssertionAxiom;
@protocol OWLClassExpression;
@protocol OWLDeclarationAxiom;
@protocol OWLDisjointClassesAxiom;
@protocol OWLEntity;
@protocol OWLEquivalentClassesAxiom;
@protocol OWLIndividual;
@protocol OWLNamedIndividual;
@protocol OWLObjectAllValuesFrom;
@protocol OWLObjectComplementOf;
@protocol OWLObjectExactCardinality;
@protocol OWLObjectIntersectionOf;
@protocol OWLObjectMaxCardinality;
@protocol OWLObjectMinCardinality;
@protocol OWLObjectProperty;
@protocol OWLObjectPropertyAssertionAxiom;
@protocol OWLObjectPropertyDomainAxiom;
@protocol OWLObjectPropertyRangeAxiom;
@protocol OWLObjectPropertyExpression;
@protocol OWLObjectSomeValuesFrom;
@protocol OWLSubClassOfAxiom;
@protocol OWLTransitiveObjectPropertyAxiom;

@class OWLIRI;

NS_ASSUME_NONNULL_BEGIN

/// An interface for creating entities, class expressions and axioms.
@protocol OWLDataFactory <NSObject>

#pragma mark OWL vocabulary

/**
 * Gets the built in owl:Thing class.
 *
 * @return OWLClass corresponding to owl:Thing.
 */
- (id<OWLClass>)thing;

/**
 * Gets the built in owl:Nothing class.
 *
 * @return OWLClass corresponding to owl:Nothing.
 */
- (id<OWLClass>)nothing;

/**
 * Gets the built in owl:topObjectProperty class.
 *
 * @return OWLObjectProperty corresponding to owl:topObjectProperty.
 */
- (id<OWLObjectProperty>)topObjectProperty;

/**
 * Gets the built in owl:bottomObjectProperty class.
 *
 * @return OWLObjectProperty corresponding to owl:bottomObjectProperty.
 */
- (id<OWLObjectProperty>)bottomObjectProperty;

#pragma mark Entities

/**
 * Gets an entity that has the specified IRI and is of the specified type.
 *
 * @param type The type of the entity that will be returned.
 * @param iri The IRI of the entity that will be returned.
 *
 * @return An entity that has the same IRI as this entity and is of the specified type.
 */
- (id<OWLEntity>)entityWithType:(OWLEntityType)type iri:(OWLIRI *)iri;

/**
 * Gets an instance of OWLClass that has the specified IRI.
 *
 * @param iri The IRI.
 *
 * @return An OWLClass that has the specified IRI.
 */
- (id<OWLClass>)classWithIRI:(OWLIRI *)iri;

/**
 * Gets an instance of OWLObjectProperty that has the specified IRI.
 *
 * @param iri The IRI.
 *
 * @return An OWLObjectProperty that has the specified IRI.
 */
- (id<OWLObjectProperty>)objectPropertyWithIRI:(OWLIRI *)iri;

/**
 * Gets an instance of OWLNamedIndividual that has the specified IRI.
 *
 * @param iri The IRI.
 *
 * @return An OWLNamedIndividual that has the specified IRI.
 */
- (id<OWLNamedIndividual>)namedIndividualWithIRI:(OWLIRI *)iri;

/**
 * Gets an OWLAnonymousIndividual. The NodeID for the individual will be generated automatically.
 * Successive invocations of this method (on this object) will result in instances of
 * OWLAnonymousIndividual that do not have NodeIDs that have been used previously.
 *
 * @return An instance of OWLAnonymousIndividual.
 */
- (id<OWLAnonymousIndividual>)anonymousIndividual;

/**
 * Gets an OWLAnonymousIndividual that has a specific NodeID.
 *
 * @param nodeID The node ID.
 *
 * @return An instance of OWLAnonymousIndividual.
 */
- (id<OWLAnonymousIndividual>)anonymousIndividualWithNodeID:(OWLNodeID)nodeID;

#pragma mark Class expressions

/**
 * Gets an instance of OWLObjectComplementOf.
 *
 * @param classExpression The class expression to complement.
 *
 * @return An instance of OWLObjectComplementOf.
 */
- (id<OWLObjectComplementOf>)objectComplementOf:(id<OWLClassExpression>)classExpression;

/**
 * Gets an instance of OWLObjectIntersectionOf.
 *
 * @param classExpressions The class expressions to intersect.
 *
 * @return An instance of OWLObjectIntersectionOf.
 */
- (id<OWLObjectIntersectionOf>)objectIntersectionOf:(NSSet<id<OWLClassExpression>> *)classExpressions;

/**
 * Gets an instance of OWLObjectAllValuesFrom.
 *
 * @param property The property that the restriction acts along.
 * @param filler The filler of the restriction.
 *
 * @return An instance of OWLObjectAllValuesFrom.
 */
- (id<OWLObjectAllValuesFrom>)objectAllValuesFrom:(id<OWLObjectPropertyExpression>)property filler:(id<OWLClassExpression>)filler;

/**
 * Gets an instance of OWLObjectSomeValuesFrom.
 *
 * @param property The property that the restriction acts along.
 * @param filler The filler of the restriction.
 *
 * @return An instance of OWLObjectSomeValuesFrom.
 */
- (id<OWLObjectSomeValuesFrom>)objectSomeValuesFrom:(id<OWLObjectPropertyExpression>)property filler:(id<OWLClassExpression>)filler;

/**
 * Gets an instance of OWLObjectExactCardinality (non-qualified).
 *
 * @param property The property.
 * @param cardinality The cardinality (cannot be negative).
 *
 * @return An instance of OWLObjectExactCardinality.
 */
- (id<OWLObjectExactCardinality>)objectExactCardinality:(id<OWLObjectPropertyExpression>)property cardinality:(NSUInteger)cardinality;

/**
 * Gets an instance of OWLObjectExactCardinality (qualified).
 *
 * @param property The property.
 * @param cardinality The cardinality (cannot be negative).
 * @param filler The filler.
 *
 * @return An instance of OWLObjectExactCardinality.
 */
- (id<OWLObjectExactCardinality>)objectExactCardinality:(id<OWLObjectPropertyExpression>)property cardinality:(NSUInteger)cardinality filler:(id<OWLClassExpression>)filler;

/**
 * Gets an instance of OWLObjectMaxCardinality (non-qualified).
 *
 * @param property The property.
 * @param cardinality The cardinality (cannot be negative).
 *
 * @return An instance of OWLObjectMaxCardinality.
 */
- (id<OWLObjectMaxCardinality>)objectMaxCardinality:(id<OWLObjectPropertyExpression>)property cardinality:(NSUInteger)cardinality;

/**
 * Gets an instance of OWLObjectMaxCardinality (qualified).
 *
 * @param property The property.
 * @param cardinality The cardinality (cannot be negative).
 * @param filler The filler.
 *
 * @return An instance of OWLObjectMaxCardinality.
 */
- (id<OWLObjectMaxCardinality>)objectMaxCardinality:(id<OWLObjectPropertyExpression>)property cardinality:(NSUInteger)cardinality filler:(id<OWLClassExpression>)filler;

/**
 * Gets an instance of OWLObjectMinCardinality (non-qualified).
 *
 * @param property The property.
 * @param cardinality The cardinality (cannot be negative).
 *
 * @return An instance of OWLObjectMinCardinality.
 */
- (id<OWLObjectMinCardinality>)objectMinCardinality:(id<OWLObjectPropertyExpression>)property cardinality:(NSUInteger)cardinality;

/**
 * Gets an instance of OWLObjectMinCardinality (qualified).
 *
 * @param property The property.
 * @param cardinality The cardinality (cannot be negative).
 * @param filler The filler.
 *
 * @return An instance of OWLObjectMinCardinality.
 */
- (id<OWLObjectMinCardinality>)objectMinCardinality:(id<OWLObjectPropertyExpression>)property cardinality:(NSUInteger)cardinality filler:(id<OWLClassExpression>)filler;

#pragma mark Axioms

/**
 * Gets a declaration for an entity.
 *
 * @param entity The declared entity.
 *
 * @return The declaration axiom for the specified entity.
 */
- (id<OWLDeclarationAxiom>)declarationAxiom:(id<OWLEntity>)entity;

/**
 * Gets an instance of OWLSubClassOfAxiom.
 *
 * @param superClass The superclass.
 * @param subClass The subclass.
 *
 * @return An instance of OWLSubClassOfAxiom.
 */
- (id<OWLSubClassOfAxiom>)subClassOfAxiom:(id<OWLClassExpression>)superClass subClass:(id<OWLClassExpression>)subClass;

/**
 * Gets an instance of OWLDisjointClassesAxiom.
 *
 * @param classExpressions The disjoint classes.
 *
 * @return An instance of OWLDisjointClassesAxiom.
 */
- (id<OWLDisjointClassesAxiom>)disjointClassesAxiom:(NSSet<id<OWLClassExpression>> *)classExpressions;

/**
 * Gets an instance of OWLEquivalentClassesAxiom.
 *
 * @param classExpressions The equivalent classes.
 *
 * @return An instance of OWLEquivalentClassesAxiom.
 */
- (id<OWLEquivalentClassesAxiom>)equivalentClassesAxiom:(NSSet<id<OWLClassExpression>> *)classExpressions;

/**
 * Gets an instance of OWLClassAssertionAxiom.
 *
 * @param individual The individual.
 * @param classExpression The class expression.
 *
 * @return An instance of OWLClassAssertionAxiom.
 */
- (id<OWLClassAssertionAxiom>)classAssertionAxiom:(id<OWLIndividual>)individual classExpression:(id<OWLClassExpression>)classExpression;

/**
 * Gets an instance of OWLObjectPropertyAssertionAxiom.
 *
 * @param subject The subject individual.
 * @param property The property.
 * @param object The object individual.
 *
 * @return An instance of OWLObjectPropertyAssertionAxiom.
 */
- (id<OWLObjectPropertyAssertionAxiom>)objectPropertyAssertionAxiom:(id<OWLIndividual>)subject property:(id<OWLObjectPropertyExpression>)property object:(id<OWLIndividual>)object;

/**
 * Gets an instance of OWLObjectPropertyDomainAxiom.
 *
 * @param property The property.
 * @param domain The domain.
 *
 * @return An instance of OWLObjectPropertyDomainAxiom.
 */
- (id<OWLObjectPropertyDomainAxiom>)objectPropertyDomainAxiom:(id<OWLObjectPropertyExpression>)property domain:(id<OWLClassExpression>)domain;

/**
 * Gets an instance of OWLObjectPropertyRangeAxiom.
 *
 * @param property The property.
 * @param range The range.
 *
 * @return An instance of OWLObjectPropertyRangeAxiom.
 */
- (id<OWLObjectPropertyRangeAxiom>)objectPropertyRangeAxiom:(id<OWLObjectPropertyExpression>)property range:(id<OWLClassExpression>)range;

/**
 * Gets an instance of OWLTransitiveObjectPropertyAxiom.
 *
 * @param property The property.
 *
 * @return An instance of OWLTransitiveObjectPropertyAxiom.
 */
- (id<OWLTransitiveObjectPropertyAxiom>)transitiveObjectPropertyAxiom:(id<OWLObjectPropertyExpression>)property;

@end

NS_ASSUME_NONNULL_END
