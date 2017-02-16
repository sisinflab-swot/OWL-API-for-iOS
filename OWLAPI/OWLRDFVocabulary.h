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

+ (OWLRDFTerm *)RDFFirst;
+ (OWLRDFTerm *)RDFNil;
+ (OWLRDFTerm *)RDFRest;
+ (OWLRDFTerm *)RDFType;
+ (OWLRDFTerm *)RDFSComment;
+ (OWLRDFTerm *)RDFSDatatype;
+ (OWLRDFTerm *)RDFSDomain;
+ (OWLRDFTerm *)RDFSRange;
+ (OWLRDFTerm *)RDFSSubClassOf;
+ (OWLRDFTerm *)RDFSSubPropertyOf;

+ (OWLRDFTerm *)OWLAllDifferent;
+ (OWLRDFTerm *)OWLAllDisjointClasses;
+ (OWLRDFTerm *)OWLAllDisjointProperties;
+ (OWLRDFTerm *)OWLAllValuesFrom;
+ (OWLRDFTerm *)OWLAnnotatedProperty;
+ (OWLRDFTerm *)OWLAnnotatedSource;
+ (OWLRDFTerm *)OWLAnnotatedTarget;
+ (OWLRDFTerm *)OWLAnnotation;
+ (OWLRDFTerm *)OWLAnnotationProperty;
+ (OWLRDFTerm *)OWLAssertionProperty;
+ (OWLRDFTerm *)OWLAsymmetricProperty;
+ (OWLRDFTerm *)OWLAxiom;
+ (OWLRDFTerm *)OWLCardinality;
+ (OWLRDFTerm *)OWLClass;
+ (OWLRDFTerm *)OWLComplementOf;
+ (OWLRDFTerm *)OWLDatatypeComplementOf;
+ (OWLRDFTerm *)OWLDatatypeProperty;
+ (OWLRDFTerm *)OWLDeprecatedClass;
+ (OWLRDFTerm *)OWLDeprecatedProperty;
+ (OWLRDFTerm *)OWLDifferentFrom;
+ (OWLRDFTerm *)OWLDisjointUnionOf;
+ (OWLRDFTerm *)OWLDisjointWith;
+ (OWLRDFTerm *)OWLDistinctMembers;
+ (OWLRDFTerm *)OWLEquivalentClass;
+ (OWLRDFTerm *)OWLEquivalentProperty;
+ (OWLRDFTerm *)OWLFunctionalProperty;
+ (OWLRDFTerm *)OWLHasKey;
+ (OWLRDFTerm *)OWLHasValue;
+ (OWLRDFTerm *)OWLImports;
+ (OWLRDFTerm *)OWLIntersectionOf;
+ (OWLRDFTerm *)OWLInverseFunctionalProperty;
+ (OWLRDFTerm *)OWLInverseOf;
+ (OWLRDFTerm *)OWLIrreflexiveProperty;
+ (OWLRDFTerm *)OWLMaxCardinality;
+ (OWLRDFTerm *)OWLMaxQualifiedCardinality;
+ (OWLRDFTerm *)OWLMembers;
+ (OWLRDFTerm *)OWLMinCardinality;
+ (OWLRDFTerm *)OWLMinQualifiedCardinality;
+ (OWLRDFTerm *)OWLNamedIndividual;
+ (OWLRDFTerm *)OWLNegativePropertyAssertion;
+ (OWLRDFTerm *)OWLNothing;
+ (OWLRDFTerm *)OWLObjectProperty;
+ (OWLRDFTerm *)OWLOnClass;
+ (OWLRDFTerm *)OWLOnDataRange;
+ (OWLRDFTerm *)OWLOnDatatype;
+ (OWLRDFTerm *)OWLOneOf;
+ (OWLRDFTerm *)OWLOnProperties;
+ (OWLRDFTerm *)OWLOnProperty;
+ (OWLRDFTerm *)OWLOntology;
+ (OWLRDFTerm *)OWLOntologyProperty;
+ (OWLRDFTerm *)OWLPropertyChainAxiom;
+ (OWLRDFTerm *)OWLPropertyDisjointWith;
+ (OWLRDFTerm *)OWLQualifiedCardinality;
+ (OWLRDFTerm *)OWLReflexiveProperty;
+ (OWLRDFTerm *)OWLRestriction;
+ (OWLRDFTerm *)OWLSameAs;
+ (OWLRDFTerm *)OWLSomeValuesFrom;
+ (OWLRDFTerm *)OWLSourceIndividual;
+ (OWLRDFTerm *)OWLSymmetricProperty;
+ (OWLRDFTerm *)OWLTargetIndividual;
+ (OWLRDFTerm *)OWLTargetValue;
+ (OWLRDFTerm *)OWLThing;
+ (OWLRDFTerm *)OWLTransitiveProperty;
+ (OWLRDFTerm *)OWLUnionOf;
+ (OWLRDFTerm *)OWLVersionIRI;
+ (OWLRDFTerm *)OWLWithRestrictions;
+ (OWLRDFTerm *)OWLHasSelf;


@end

NS_ASSUME_NONNULL_END
