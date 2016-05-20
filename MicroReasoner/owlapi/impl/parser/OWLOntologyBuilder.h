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

- (nullable OWLClassExpressionBuilder *)ensureClassExpressionBuilderForID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;
- (nullable OWLClassExpressionBuilder *)classExpressionBuilderForID:(NSString *)ID;

- (nullable OWLIndividualBuilder *)ensureIndividualBuilderForID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;
- (nullable OWLIndividualBuilder *)individualBuilderForID:(NSString *)ID;

- (nullable OWLPropertyBuilder *)ensurePropertyBuilderForID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;
- (nullable OWLPropertyBuilder *)propertyBuilderForID:(NSString *)ID;

#pragma mark Axiom builders

- (OWLAxiomBuilder *)ensureDeclarationAxiomBuilderForID:(NSString *)ID;
- (nullable OWLAxiomBuilder *)declarationAxiomBuilderForID:(NSString *)ID;

- (OWLAxiomBuilder *)addSingleStatementAxiomBuilderForID:(NSString *)ID;
- (nullable OWLAxiomBuilder *)addSingleStatementAxiomBuilderForID:(NSString *)ID ensureUniqueType:(OWLABType)type;

#pragma mark Lists

- (OWLListItem *)ensureListItemForID:(NSString *)ID;
- (nullable OWLListItem *)listItemForID:(NSString *)ID;
- (NSArray *)firstItemsForListID:(NSString *)ID;

#pragma mark OWLAbstractBuilder

- (id<OWLOntology>)build;

@end

NS_ASSUME_NONNULL_END
