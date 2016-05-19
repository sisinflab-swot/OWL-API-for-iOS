//
//  OWLRDFVocabulary.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 10/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLRDFVocabulary.h"
#import "OWLNamespace.h"

#define LAZY_STATIC_TERM(name, namespace, shortname) \
static OWLRDFTerm *name##Term; \
+ (OWLRDFTerm *)name { \
if (!name##Term) { name##Term = [[OWLRDFTerm alloc] initWithNameSpace:namespace shortName:shortname]; } \
return name##Term; \
}

@implementation OWLRDFTerm

#pragma mark Properties

// IRI
@synthesize IRI = _IRI;

- (NSURL *)IRI
{
    if (!_IRI) {
        _IRI = [self.nameSpace URLWithFragment:self.shortName];
    }
    return _IRI;
}

// Others
@synthesize nameSpace = _nameSpace;
@synthesize shortName = _shortName;

#pragma mark Public methods

- (instancetype)initWithNameSpace:(NSString *)nameSpace shortName:(NSString *)shortName
{
    NSParameterAssert(nameSpace && shortName);
    
    if ((self = [super init])) {
        _nameSpace = [nameSpace copy];
        _shortName = [shortName copy];
    }
    return self;
}

- (NSString *)stringValue { return [self.nameSpace.prefix stringByAppendingString:self.shortName]; }

@end


@implementation OWLRDFVocabulary

LAZY_STATIC_TERM(RDFFirst, OWLNamespaceRDFSyntax, @"first");
LAZY_STATIC_TERM(RDFNil, OWLNamespaceRDFSyntax, @"nil");
LAZY_STATIC_TERM(RDFRest, OWLNamespaceRDFSyntax, @"rest");
LAZY_STATIC_TERM(RDFType, OWLNamespaceRDFSyntax, @"type");
LAZY_STATIC_TERM(RDFSDatatype, OWLNamespaceRDFSchema, @"datatype");
LAZY_STATIC_TERM(RDFSSubClassOf, OWLNamespaceRDFSchema, @"subClassOf");

LAZY_STATIC_TERM(OWLAllDifferent, OWLNamespaceOWL, @"AllDifferent");
LAZY_STATIC_TERM(OWLAllDisjointClasses, OWLNamespaceOWL, @"AllDisjointClasses");
LAZY_STATIC_TERM(OWLAllDisjointProperties, OWLNamespaceOWL, @"AllDisjointProperties");
LAZY_STATIC_TERM(OWLAllValuesFrom, OWLNamespaceOWL, @"allValuesFrom");
LAZY_STATIC_TERM(OWLAnnotation, OWLNamespaceOWL, @"Annotation");
LAZY_STATIC_TERM(OWLAnnotationProperty, OWLNamespaceOWL, @"AnnotationProperty");
LAZY_STATIC_TERM(OWLAsymmetricProperty, OWLNamespaceOWL, @"AsymmetricProperty");
LAZY_STATIC_TERM(OWLAxiom, OWLNamespaceOWL, @"Axiom");
LAZY_STATIC_TERM(OWLCardinality, OWLNamespaceOWL, @"cardinality");
LAZY_STATIC_TERM(OWLClass, OWLNamespaceOWL, @"Class");
LAZY_STATIC_TERM(OWLDatatypeProperty, OWLNamespaceOWL, @"DatatypeProperty");
LAZY_STATIC_TERM(OWLDeprecatedClass, OWLNamespaceOWL, @"DeprecatedClass");
LAZY_STATIC_TERM(OWLDeprecatedProperty, OWLNamespaceOWL, @"DeprecatedProperty");
LAZY_STATIC_TERM(OWLDisjointWith, OWLNamespaceOWL, @"disjointWith");
LAZY_STATIC_TERM(OWLEquivalentClass, OWLNamespaceOWL, @"equivalentClass");
LAZY_STATIC_TERM(OWLFunctionalProperty, OWLNamespaceOWL, @"FunctionalProperty");
LAZY_STATIC_TERM(OWLIntersectionOf, OWLNamespaceOWL, @"intersectionOf");
LAZY_STATIC_TERM(OWLInverseFunctionalProperty, OWLNamespaceOWL, @"InverseFunctionalProperty");
LAZY_STATIC_TERM(OWLIrreflexiveProperty, OWLNamespaceOWL, @"IrreflexiveProperty");
LAZY_STATIC_TERM(OWLMaxCardinality, OWLNamespaceOWL, @"maxCardinality");
LAZY_STATIC_TERM(OWLMinCardinality, OWLNamespaceOWL, @"minCardinality");
LAZY_STATIC_TERM(OWLNamedIndividual, OWLNamespaceOWL, @"NamedIndividual");
LAZY_STATIC_TERM(OWLNegativePropertyAssertion, OWLNamespaceOWL, @"NegativePropertyAssertion");
LAZY_STATIC_TERM(OWLNothing, OWLNamespaceOWL, @"Nothing");
LAZY_STATIC_TERM(OWLObjectProperty, OWLNamespaceOWL, @"ObjectProperty");
LAZY_STATIC_TERM(OWLOnProperty, OWLNamespaceOWL, @"onProperty");
LAZY_STATIC_TERM(OWLOntology, OWLNamespaceOWL, @"Ontology");
LAZY_STATIC_TERM(OWLOntologyProperty, OWLNamespaceOWL, @"OntologyProperty");
LAZY_STATIC_TERM(OWLReflexiveProperty, OWLNamespaceOWL, @"ReflexiveProperty");
LAZY_STATIC_TERM(OWLRestriction, OWLNamespaceOWL, @"Restriction");
LAZY_STATIC_TERM(OWLSomeValuesFrom, OWLNamespaceOWL, @"someValuesFrom");
LAZY_STATIC_TERM(OWLSymmetricProperty, OWLNamespaceOWL, @"SymmetricProperty");
LAZY_STATIC_TERM(OWLThing, OWLNamespaceOWL, @"Thing");
LAZY_STATIC_TERM(OWLTransitiveProperty, OWLNamespaceOWL, @"TransitiveProperty");

@end
