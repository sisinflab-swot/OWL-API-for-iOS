//
//  Created by Ivano Bilenchi on 13/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAbstractBuilder.h"
#import "OWLAxiomBuilderType.h"

@protocol OWLClassExpression;
@protocol OWLIndividual;
@protocol OWLOntology;
@protocol OWLOntologyManager;
@protocol OWLPropertyExpression;

@class OWLAxiomBuilder;
@class OWLClassExpressionBuilder;
@class OWLIndividualBuilder;
@class OWLIRI;
@class OWLListItem;
@class OWLPropertyBuilder;

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyBuilder : NSObject <OWLAbstractBuilder>


#pragma mark Ontology header

/// The ontology IRI of the built ontology.
DECLARE_BUILDER_CSTRING_PROPERTY(ontologyIRI, OntologyIRI)

/// The version IRI of the built ontology.
DECLARE_BUILDER_CSTRING_PROPERTY(versionIRI, VersionIRI)


#pragma mark Entity builders

// OWL DL entities should have a unique ID (blank node or IRI), therefore these
// setters return NO if a named entity with the specified ID already exists.

- (OWLClassExpressionBuilder *)ensureClassExpressionBuilderForID:(unsigned char *)ID;
- (nullable OWLClassExpressionBuilder *)classExpressionBuilderForID:(unsigned char *)ID;

- (OWLIndividualBuilder *)ensureIndividualBuilderForID:(unsigned char *)ID;
- (nullable OWLIndividualBuilder *)individualBuilderForID:(unsigned char *)ID;

- (OWLPropertyBuilder *)ensurePropertyBuilderForID:(unsigned char *)ID;
- (nullable OWLPropertyBuilder *)propertyBuilderForID:(unsigned char *)ID;


#pragma mark Axiom builders

- (OWLAxiomBuilder *)ensureDeclarationAxiomBuilderForID:(unsigned char *)ID;
- (OWLAxiomBuilder *)addSingleStatementAxiomBuilder;


#pragma mark Lists

- (OWLListItem *)ensureListItemForID:(unsigned char *)ID;
- (nullable OWLListItem *)listItemForID:(unsigned char *)ID;
- (void)iterateFirstItemsForListID:(unsigned char *)ID withHandler:(void (^)(unsigned char *firstID))handler;


#pragma mark OWLAbstractBuilder

- (id<OWLOntology>)build;


#pragma mark Lifecycle

- (instancetype)initWithManager:(id<OWLOntologyManager>)manager;

@end

NS_ASSUME_NONNULL_END
