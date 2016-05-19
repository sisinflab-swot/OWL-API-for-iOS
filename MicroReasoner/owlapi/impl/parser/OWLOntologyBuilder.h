//
//  OWLOntologyInternalsBuilder.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 13/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAbstractBuilder.h"
#import "OWLAxiomBuilderType.h"

@protocol OWLOntology;

@class OWLAxiomBuilder;
@class OWLClassExpressionBuilder;
@class OWLIndividualBuilder;
@class OWLListItem;
@class OWLPropertyBuilder;

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyBuilder : NSObject <OWLAbstractBuilder>

#pragma mark Entity builders

// OWL DL entities should have a unique ID (blank node or IRI), therefore these
// setters return NO if a named entity with the specified ID already exists.

- (nullable id<OWLAbstractBuilder>)entityBuilderForID:(NSString *)ID;

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
- (nullable OWLAxiomBuilder *)addSingleStatementAxiomBuilderForID:(NSString *)ID ensureUniqueType:(OWLABType)type;

#pragma mark Lists

- (OWLListItem *)ensureListItemForID:(NSString *)ID;
- (nullable OWLListItem *)listItemForID:(NSString *)ID;

#pragma mark OWLAbstractBuilder

- (id<OWLOntology>)build;

@end

NS_ASSUME_NONNULL_END
