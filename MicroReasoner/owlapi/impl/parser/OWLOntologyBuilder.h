//
//  OWLOntologyInternalsBuilder.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 13/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAbstractBuilder.h"

@protocol OWLOntology;

@class OWLAxiomBuilder;
@class OWLClassExpressionBuilder;
@class OWLIndividualBuilder;
@class OWLPropertyBuilder;

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyBuilder : NSObject <OWLAbstractBuilder>

#pragma mark Entity builders accessor methods

// OWL DL entities should have a unique ID (blank node or IRI), therefore these
// setters return NO if a named entity with the specified ID already exists.

- (nullable id<OWLAbstractBuilder>)entityBuilderForID:(NSString *)ID;

- (nullable OWLClassExpressionBuilder *)classExpressionBuilderForID:(NSString *)ID;
- (BOOL)setClassExpressionBuilder:(OWLClassExpressionBuilder *)builder forID:(NSString *)ID;

- (nullable OWLIndividualBuilder *)individualBuilderForID:(NSString *)ID;
- (BOOL)setIndividualBuilder:(OWLIndividualBuilder *)builder forID:(NSString *)ID;

- (nullable OWLPropertyBuilder *)propertyBuilderForID:(NSString *)ID;
- (BOOL)setPropertyBuilder:(OWLPropertyBuilder *)builder forID:(NSString *)ID;

#pragma mark Axiom builders accessor methods

- (nullable OWLAxiomBuilder *)declarationAxiomBuilderForID:(NSString *)ID;
- (void)setDeclarationAxiomBuilder:(OWLAxiomBuilder *)builder forID:(NSString *)ID;

#pragma mark OWLAbstractBuilder

- (id<OWLOntology>)build;

@end

NS_ASSUME_NONNULL_END
