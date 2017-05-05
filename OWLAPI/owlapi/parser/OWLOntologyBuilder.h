//
//  Created by Ivano Bilenchi on 13/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAbstractBuilder.h"
#import "OWLAxiomBuilderType.h"

@protocol OWLClassExpression;
@protocol OWLIndividual;
@protocol OWLOntology;
@protocol OWLPropertyExpression;

@class OWLAxiomBuilder;
@class OWLClassExpressionBuilder;
@class OWLIndividualBuilder;
@class OWLListItem;
@class OWLPropertyBuilder;

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyBuilder : NSObject <OWLAbstractBuilder>

#pragma mark Ontology header

/// Sets the ontology IRI of the built ontology.
- (BOOL)setOntologyIRI:(NSString *)IRI error:(NSError *_Nullable __autoreleasing *)error;

/// Sets the version IRI of the built ontology.
- (BOOL)setVersionIRI:(NSString *)IRI error:(NSError *_Nullable __autoreleasing *)error;

#pragma mark Entity builders

// OWL DL entities should have a unique ID (blank node or IRI), therefore these
// setters return NO if a named entity with the specified ID already exists.

- (OWLClassExpressionBuilder *)ensureClassExpressionBuilderForID:(NSString *)ID;
- (nullable OWLClassExpressionBuilder *)classExpressionBuilderForID:(NSString *)ID;

- (OWLIndividualBuilder *)ensureIndividualBuilderForID:(NSString *)ID;
- (nullable OWLIndividualBuilder *)individualBuilderForID:(NSString *)ID;

- (OWLPropertyBuilder *)ensurePropertyBuilderForID:(NSString *)ID;
- (nullable OWLPropertyBuilder *)propertyBuilderForID:(NSString *)ID;

#pragma mark Axiom builders

- (OWLAxiomBuilder *)ensureDeclarationAxiomBuilderForID:(NSString *)ID;
- (nullable OWLAxiomBuilder *)declarationAxiomBuilderForID:(NSString *)ID;

- (OWLAxiomBuilder *)addSingleStatementAxiomBuilderForID:(NSString *)ID;

#pragma mark Lists

- (OWLListItem *)ensureListItemForID:(NSString *)ID;
- (nullable OWLListItem *)listItemForID:(NSString *)ID;
- (NSArray *)firstItemsForListID:(NSString *)ID;

#pragma mark OWLAbstractBuilder

- (id<OWLOntology>)build;

@end

NS_ASSUME_NONNULL_END
