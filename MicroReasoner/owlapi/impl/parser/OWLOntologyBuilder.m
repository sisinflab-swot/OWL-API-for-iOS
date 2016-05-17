//
//  OWLOntologyInternalsBuilder.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 13/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntologyBuilder.h"
#import "OWLAxiom.h"
#import "OWLAxiomBuilder.h"
#import "OWLDeclarationAxiom.h"
#import "OWLEntity.h"
#import "OWLNamedIndividual.h"
#import "OWLOntologyID.h"
#import "OWLOntologyImpl.h"
#import "OWLOntologyInternals.h"
#import "SMRPreprocessor.h"

@interface OWLOntologyBuilder ()

/// Ensures uniqueness of entity identifiers.
@property (nonatomic, strong, readonly)
NSMutableDictionary<NSString *, id<OWLAbstractBuilder>> *allEntityBuilders;

/// Blank node ID || IRI string -> OWLClassExpressionBuilder.
@property (nonatomic, strong, readonly)
NSMutableDictionary<NSString *, OWLClassExpressionBuilder *> *classExpressionBuilders;

/// Blank node ID || IRI string -> OWLAxiomBuilder.
@property (nonatomic, strong, readonly)
NSMutableDictionary<NSString *, OWLAxiomBuilder *> *declarationAxiomBuilders;

/// Blank node ID || IRI string -> OWLIndividualBuilder.
@property (nonatomic, strong, readonly)
NSMutableDictionary<NSString *, OWLIndividualBuilder *> *individualBuilders;

/// Blank node ID || IRI string -> OWLPropertyBuilder
@property (nonatomic, strong, readonly)
NSMutableDictionary<NSString *, OWLPropertyBuilder *> *propertyBuilders;

@end


@implementation OWLOntologyBuilder

SYNTHESIZE_LAZY_INIT(NSMutableDictionary, allEntityBuilders);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, classExpressionBuilders);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, declarationAxiomBuilders);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, individualBuilders);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, propertyBuilders);

#pragma mark OWLAbstractBuilder

- (id<OWLOntology>)build
{
    OWLOntologyID *ontologyID = [[OWLOntologyID alloc] initWithOntologyIRI:nil versionIRI:nil];
    OWLOntologyInternals *internals = [[OWLOntologyInternals alloc] init];
    
    // Declaration axioms
    [self.declarationAxiomBuilders enumerateKeysAndObjectsUsingBlock:^(__unused NSString * _Nonnull key, OWLAxiomBuilder * _Nonnull builder, __unused BOOL * _Nonnull stop) {
        
        id<OWLAxiom> axiom = [builder build];
        
        if (axiom && axiom.axiomType == OWLAxiomTypeDeclaration) {
            [internals addAxiom:axiom ofType:OWLAxiomTypeDeclaration];
            
            id<OWLEntity> declaredEntity = [(id<OWLDeclarationAxiom>)axiom entity];
            [self _addAxiom:axiom forEntity:declaredEntity toInternals:internals];
        }
    }];
    
    return [[OWLOntologyImpl alloc] initWithID:ontologyID internals:internals];
}

#pragma mark Entity builder accessor methods

NS_INLINE BOOL setEntityBuilder(NSMutableDictionary *allEntityBuilders, NSMutableDictionary *dict, NSString *ID, id entityBuilder)
{
    BOOL success = NO;
    
    if (!allEntityBuilders[ID]) {
        NSString *localID = [ID copy];
        dict[localID] = entityBuilder;
        allEntityBuilders[localID] = entityBuilder;
        
        success = YES;
    }
    
    return success;
}

- (id<OWLAbstractBuilder>)entityBuilderForID:(NSString *)ID { return self.allEntityBuilders[ID]; }

- (OWLClassExpressionBuilder *)classExpressionBuilderForID:(NSString *)ID
{
    return self.classExpressionBuilders[ID];
}

- (BOOL)setClassExpressionBuilder:(OWLClassExpressionBuilder *)builder forID:(NSString *)ID
{
    return setEntityBuilder(self.allEntityBuilders, self.classExpressionBuilders, ID, builder);
}

- (OWLIndividualBuilder *)individualBuilderForID:(NSString *)ID
{
    return self.individualBuilders[ID];
}

- (BOOL)setIndividualBuilder:(OWLIndividualBuilder *)builder forID:(NSString *)ID
{
    return setEntityBuilder(self.allEntityBuilders, self.individualBuilders, ID, builder);
}

- (OWLPropertyBuilder *)propertyBuilderForID:(NSString *)ID
{
    return self.propertyBuilders[ID];
}

- (BOOL)setPropertyBuilder:(OWLPropertyBuilder *)builder forID:(NSString *)ID
{
    return setEntityBuilder(self.allEntityBuilders, self.propertyBuilders, ID, builder);
}

#pragma mark Axiom builder accessor methods

- (OWLAxiomBuilder *)declarationAxiomBuilderForID:(NSString *)ID
{
    return self.declarationAxiomBuilders[ID];
}

- (void)setDeclarationAxiomBuilder:(OWLAxiomBuilder *)builder forID:(NSString *)ID
{
    self.declarationAxiomBuilders[ID] = builder;
}

#pragma mark Private methods

- (void)_addAxiom:(id<OWLAxiom>)axiom forEntity:(id<OWLEntity>)entity toInternals:(OWLOntologyInternals *)internals
{
    switch (entity.entityType) {
        case OWLEntityTypeClass:
            [internals addAxiom:axiom forClass:(id<OWLClass>)entity];
            break;
            
        case OWLEntityTypeNamedIndividual:
            [internals addAxiom:axiom forNamedIndividual:(id<OWLNamedIndividual>)entity];
            break;
            
        case OWLEntityTypeObjectProperty:
            [internals addAxiom:axiom forObjectProperty:(id<OWLObjectProperty>)entity];
            break;
            
        default:
            break;
    }
}

@end
