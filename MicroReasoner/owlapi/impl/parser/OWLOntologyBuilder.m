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

@implementation OWLOntologyBuilder

SYNTHESIZE_LAZY_INIT(NSMutableDictionary, axiomBuilders);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, classExpressionBuilders);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, individualBuilders);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, propertyBuilders);

#pragma mark OWLAbstractBuilder

- (id<OWLOntology>)build
{
    OWLOntologyID *ontologyID = [[OWLOntologyID alloc] initWithOntologyIRI:nil versionIRI:nil];
    OWLOntologyInternals *internals = [[OWLOntologyInternals alloc] init];
    
    // Axioms
    [self.axiomBuilders enumerateKeysAndObjectsUsingBlock:^(__unused NSString * _Nonnull key, OWLAxiomBuilder * _Nonnull builder, __unused BOOL * _Nonnull stop) {
        
        id<OWLAxiom> axiom = [builder build];
        
        if (axiom) {
            OWLAxiomType axiomType = axiom.axiomType;
            [internals addAxiom:axiom ofType:axiomType];
            
            switch (axiomType) {
                case OWLAxiomTypeDeclaration:
                {
                    id<OWLEntity> declaredEntity = [(id<OWLDeclarationAxiom>)axiom entity];
                    [self _addAxiom:axiom forEntity:declaredEntity toInternals:internals];
                    break;
                }
                    
                default:
                    break;
            }
        }
    }];
    
    return [[OWLOntologyImpl alloc] initWithID:ontologyID internals:internals];
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
