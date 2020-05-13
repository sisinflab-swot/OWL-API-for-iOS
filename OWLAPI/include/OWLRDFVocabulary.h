//
//  Created by Ivano Bilenchi on 10/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OWLIRI;
@class OWLNamespace;

NS_ASSUME_NONNULL_BEGIN

/// Represents a term in the OWL RDF vocabulary.
@interface OWLRDFTerm : NSObject

/// The IRI of this term.
@property (nonatomic, copy, readonly) OWLIRI *IRI;

/// The namespace of this term.
@property (nonatomic, copy, readonly) OWLNamespace *nameSpace;

/// The short name of this term.
@property (nonatomic, copy, readonly) NSString *shortName;

/// The designated initializer.
- (instancetype)initWithNameSpace:(OWLNamespace *)nameSpace shortName:(NSString *)shortName;

/**
 * Returns the concatenation of the namespace and short name of this term.
 *
 * @return The string representation of this term.
 */
- (NSString *)stringValue;

@end


/// Represents the OWL RDF vocabulary.
@interface OWLRDFVocabulary : NSObject

#pragma mark RDF Syntax

/// http://www.w3.org/1999/02/22-rdf-syntax-ns#Description
+ (OWLRDFTerm *)RDFDescription;

/// http://www.w3.org/1999/02/22-rdf-syntax-ns#first
+ (OWLRDFTerm *)RDFFirst;

/// http://www.w3.org/1999/02/22-rdf-syntax-ns#langString
+ (OWLRDFTerm *)RDFLangString;

/// http://www.w3.org/1999/02/22-rdf-syntax-ns#List
+ (OWLRDFTerm *)RDFList;

/// http://www.w3.org/1999/02/22-rdf-syntax-ns#nil
+ (OWLRDFTerm *)RDFNil;

/// http://www.w3.org/1999/02/22-rdf-syntax-ns#PlainLiteral
+ (OWLRDFTerm *)RDFPlainLiteral;

/// http://www.w3.org/1999/02/22-rdf-syntax-ns#Property
+ (OWLRDFTerm *)RDFProperty;

/// http://www.w3.org/1999/02/22-rdf-syntax-ns#rest
+ (OWLRDFTerm *)RDFRest;

/// http://www.w3.org/1999/02/22-rdf-syntax-ns#type
+ (OWLRDFTerm *)RDFType;

/// http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral
+ (OWLRDFTerm *)RDFXMLLiteral;

#pragma mark RDF Schema

/// http://www.w3.org/2000/01/rdf-schema#Class
+ (OWLRDFTerm *)RDFSClass;

/// http://www.w3.org/2000/01/rdf-schema#comment
+ (OWLRDFTerm *)RDFSComment;

/// http://www.w3.org/2000/01/rdf-schema#Datatype
+ (OWLRDFTerm *)RDFSDatatype;

/// http://www.w3.org/2000/01/rdf-schema#domain
+ (OWLRDFTerm *)RDFSDomain;

/// http://www.w3.org/2000/01/rdf-schema#isDefinedBy
+ (OWLRDFTerm *)RDFSIsDefinedBy;

/// http://www.w3.org/2000/01/rdf-schema#label
+ (OWLRDFTerm *)RDFSLabel;

/// http://www.w3.org/2000/01/rdf-schema#Literal
+ (OWLRDFTerm *)RDFSLiteral;

/// http://www.w3.org/2000/01/rdf-schema#range
+ (OWLRDFTerm *)RDFSRange;

/// http://www.w3.org/2000/01/rdf-schema#Resource
+ (OWLRDFTerm *)RDFSResource;

/// http://www.w3.org/2000/01/rdf-schema#seeAlso
+ (OWLRDFTerm *)RDFSSeeAlso;

/// http://www.w3.org/2000/01/rdf-schema#subClassOf
+ (OWLRDFTerm *)RDFSSubClassOf;

/// http://www.w3.org/2000/01/rdf-schema#subPropertyOf
+ (OWLRDFTerm *)RDFSSubPropertyOf;

#pragma mark OWL

/// http://www.w3.org/2002/07/owl#AllDifferent
+ (OWLRDFTerm *)OWLAllDifferent;

/// http://www.w3.org/2002/07/owl#AllDisjointClasses
+ (OWLRDFTerm *)OWLAllDisjointClasses;

/// http://www.w3.org/2002/07/owl#AllDisjointProperties
+ (OWLRDFTerm *)OWLAllDisjointProperties;

/// http://www.w3.org/2002/07/owl#allValuesFrom
+ (OWLRDFTerm *)OWLAllValuesFrom;

/// http://www.w3.org/2002/07/owl#annotatedProperty
+ (OWLRDFTerm *)OWLAnnotatedProperty;

/// http://www.w3.org/2002/07/owl#annotatedSource
+ (OWLRDFTerm *)OWLAnnotatedSource;

/// http://www.w3.org/2002/07/owl#annotatedTarget
+ (OWLRDFTerm *)OWLAnnotatedTarget;

/// http://www.w3.org/2002/07/owl#Annotation
+ (OWLRDFTerm *)OWLAnnotation;

/// http://www.w3.org/2002/07/owl#AnnotationProperty
+ (OWLRDFTerm *)OWLAnnotationProperty;

/// http://www.w3.org/2002/07/owl#assertionProperty
+ (OWLRDFTerm *)OWLAssertionProperty;

/// http://www.w3.org/2002/07/owl#AsymmetricProperty
+ (OWLRDFTerm *)OWLAsymmetricProperty;

/// http://www.w3.org/2002/07/owl#Axiom
+ (OWLRDFTerm *)OWLAxiom;

/// http://www.w3.org/2002/07/owl#backwardCompatibleWith
+ (OWLRDFTerm *)OWLBackwardCompatibleWith;

/// http://www.w3.org/2002/07/owl#bottomDataProperty
+ (OWLRDFTerm *)OWLBottomDataProperty;

/// http://www.w3.org/2002/07/owl#bottomObjectProperty
+ (OWLRDFTerm *)OWLBottomObjectProperty;

/// http://www.w3.org/2002/07/owl#cardinality
+ (OWLRDFTerm *)OWLCardinality;

/// http://www.w3.org/2002/07/owl#Class
+ (OWLRDFTerm *)OWLClass;

/// http://www.w3.org/2002/07/owl#complementOf
+ (OWLRDFTerm *)OWLComplementOf;

/// http://www.w3.org/2002/07/owl#DataRange
+ (OWLRDFTerm *)OWLDataRange;

/// http://www.w3.org/2002/07/owl#Datatype
+ (OWLRDFTerm *)OWLDatatype;

/// http://www.w3.org/2002/07/owl#datatypeComplementOf
+ (OWLRDFTerm *)OWLDatatypeComplementOf;

/// http://www.w3.org/2002/07/owl#DatatypeProperty
+ (OWLRDFTerm *)OWLDatatypeProperty;

/// http://www.w3.org/2002/07/owl#deprecated
+ (OWLRDFTerm *)OWLDeprecated;

/// http://www.w3.org/2002/07/owl#DeprecatedClass
+ (OWLRDFTerm *)OWLDeprecatedClass;

/// http://www.w3.org/2002/07/owl#DeprecatedProperty
+ (OWLRDFTerm *)OWLDeprecatedProperty;

/// http://www.w3.org/2002/07/owl#differentFrom
+ (OWLRDFTerm *)OWLDifferentFrom;

/// http://www.w3.org/2002/07/owl#disjointUnionOf
+ (OWLRDFTerm *)OWLDisjointUnionOf;

/// http://www.w3.org/2002/07/owl#disjointWith
+ (OWLRDFTerm *)OWLDisjointWith;

/// http://www.w3.org/2002/07/owl#distinctMembers
+ (OWLRDFTerm *)OWLDistinctMembers;

/// http://www.w3.org/2002/07/owl#equivalentClass
+ (OWLRDFTerm *)OWLEquivalentClass;

/// http://www.w3.org/2002/07/owl#equivalentProperty
+ (OWLRDFTerm *)OWLEquivalentProperty;

/// http://www.w3.org/2002/07/owl#FunctionalProperty
+ (OWLRDFTerm *)OWLFunctionalProperty;

/// http://www.w3.org/2002/07/owl#hasKey
+ (OWLRDFTerm *)OWLHasKey;

/// http://www.w3.org/2002/07/owl#hasSelf
+ (OWLRDFTerm *)OWLHasSelf;

/// http://www.w3.org/2002/07/owl#hasValue
+ (OWLRDFTerm *)OWLHasValue;

/// http://www.w3.org/2002/07/owl#imports
+ (OWLRDFTerm *)OWLImports;

/// http://www.w3.org/2002/07/owl#incompatibleWith
+ (OWLRDFTerm *)OWLIncompatibleWith;

/// http://www.w3.org/2002/07/owl#Individual
+ (OWLRDFTerm *)OWLIndividual;

/// http://www.w3.org/2002/07/owl#intersectionOf
+ (OWLRDFTerm *)OWLIntersectionOf;

/// http://www.w3.org/2002/07/owl#InverseFunctionalProperty
+ (OWLRDFTerm *)OWLInverseFunctionalProperty;

/// http://www.w3.org/2002/07/owl#inverseObjectPropertyExpression
+ (OWLRDFTerm *)OWLInverseObjectPropertyExpression;

/// http://www.w3.org/2002/07/owl#inverseOf
+ (OWLRDFTerm *)OWLInverseOf;

/// http://www.w3.org/2002/07/owl#IrreflexiveProperty
+ (OWLRDFTerm *)OWLIrreflexiveProperty;

/// http://www.w3.org/2002/07/owl#maxCardinality
+ (OWLRDFTerm *)OWLMaxCardinality;

/// http://www.w3.org/2002/07/owl#maxQualifiedCardinality
+ (OWLRDFTerm *)OWLMaxQualifiedCardinality;

/// http://www.w3.org/2002/07/owl#members
+ (OWLRDFTerm *)OWLMembers;

/// http://www.w3.org/2002/07/owl#minCardinality
+ (OWLRDFTerm *)OWLMinCardinality;

/// http://www.w3.org/2002/07/owl#minQualifiedCardinality
+ (OWLRDFTerm *)OWLMinQualifiedCardinality;

/// http://www.w3.org/2002/07/owl#NamedIndividual
+ (OWLRDFTerm *)OWLNamedIndividual;

/// http://www.w3.org/2002/07/owl#NegativePropertyAssertion
+ (OWLRDFTerm *)OWLNegativePropertyAssertion;

/// http://www.w3.org/2002/07/owl#Nothing
+ (OWLRDFTerm *)OWLNothing;

/// http://www.w3.org/2002/07/owl#ObjectProperty
+ (OWLRDFTerm *)OWLObjectProperty;

/// http://www.w3.org/2002/07/owl#onClass
+ (OWLRDFTerm *)OWLOnClass;

/// http://www.w3.org/2002/07/owl#onDataRange
+ (OWLRDFTerm *)OWLOnDataRange;

/// http://www.w3.org/2002/07/owl#onDatatype
+ (OWLRDFTerm *)OWLOnDatatype;

/// http://www.w3.org/2002/07/owl#oneOf
+ (OWLRDFTerm *)OWLOneOf;

/// http://www.w3.org/2002/07/owl#onProperties
+ (OWLRDFTerm *)OWLOnProperties;

/// http://www.w3.org/2002/07/owl#onProperty
+ (OWLRDFTerm *)OWLOnProperty;

/// http://www.w3.org/2002/07/owl#Ontology
+ (OWLRDFTerm *)OWLOntology;

/// http://www.w3.org/2002/07/owl#OntologyProperty
+ (OWLRDFTerm *)OWLOntologyProperty;

/// http://www.w3.org/2002/07/owl#priorVersion
+ (OWLRDFTerm *)OWLPriorVersion;

/// http://www.w3.org/2002/07/owl#propertyChainAxiom
+ (OWLRDFTerm *)OWLPropertyChainAxiom;

/// http://www.w3.org/2002/07/owl#propertyDisjointWith
+ (OWLRDFTerm *)OWLPropertyDisjointWith;

/// http://www.w3.org/2002/07/owl#qualifiedCardinality
+ (OWLRDFTerm *)OWLQualifiedCardinality;

/// http://www.w3.org/2002/07/owl#ReflexiveProperty
+ (OWLRDFTerm *)OWLReflexiveProperty;

/// http://www.w3.org/2002/07/owl#Restriction
+ (OWLRDFTerm *)OWLRestriction;

/// http://www.w3.org/2002/07/owl#sameAs
+ (OWLRDFTerm *)OWLSameAs;

/// http://www.w3.org/2002/07/owl#someValuesFrom
+ (OWLRDFTerm *)OWLSomeValuesFrom;

/// http://www.w3.org/2002/07/owl#sourceIndividual
+ (OWLRDFTerm *)OWLSourceIndividual;

/// http://www.w3.org/2002/07/owl#SymmetricProperty
+ (OWLRDFTerm *)OWLSymmetricProperty;

/// http://www.w3.org/2002/07/owl#targetIndividual
+ (OWLRDFTerm *)OWLTargetIndividual;

/// http://www.w3.org/2002/07/owl#targetValue
+ (OWLRDFTerm *)OWLTargetValue;

/// http://www.w3.org/2002/07/owl#Thing
+ (OWLRDFTerm *)OWLThing;

/// http://www.w3.org/2002/07/owl#topDataProperty
+ (OWLRDFTerm *)OWLTopDataProperty;

/// http://www.w3.org/2002/07/owl#topObjectProperty
+ (OWLRDFTerm *)OWLTopObjectProperty;

/// http://www.w3.org/2002/07/owl#TransitiveProperty
+ (OWLRDFTerm *)OWLTransitiveProperty;

/// http://www.w3.org/2002/07/owl#unionOf
+ (OWLRDFTerm *)OWLUnionOf;

/// http://www.w3.org/2002/07/owl#versionIRI
+ (OWLRDFTerm *)OWLVersionIRI;

/// http://www.w3.org/2002/07/owl#versionInfo
+ (OWLRDFTerm *)OWLVersionInfo;

/// http://www.w3.org/2002/07/owl#withRestrictions
+ (OWLRDFTerm *)OWLWithRestrictions;


@end

NS_ASSUME_NONNULL_END
