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
#import "OWLClassExpression.h"
#import "OWLClassExpressionBuilder.h"
#import "OWLDeclarationAxiom.h"
#import "OWLEntity.h"
#import "OWLIndividualBuilder.h"
#import "OWLListItem.h"
#import "OWLNamedIndividual.h"
#import "OWLOntologyID.h"
#import "OWLOntologyImpl.h"
#import "OWLOntologyInternals.h"
#import "OWLPropertyBuilder.h"
#import "OWLSubClassOfAxiom.h"
#import "SMRPreprocessor.h"

@interface OWLOntologyBuilder ()

// The keys of these dictionaries are either blank node IDs or IRIs,
// matching the subject node of the statement that triggered the
// creation of the builder/item.

@property (nonatomic, strong, readonly)
NSMutableDictionary<NSString *, id<OWLAbstractBuilder>> *allEntityBuilders;

@property (nonatomic, strong, readonly)
NSMutableDictionary<NSString *, OWLClassExpressionBuilder *> *classExpressionBuilders;

@property (nonatomic, strong, readonly)
NSMutableDictionary<NSString *, OWLAxiomBuilder *> *declarationAxiomBuilders;

@property (nonatomic, strong, readonly)
NSMutableDictionary<NSString *, OWLIndividualBuilder *> *individualBuilders;

@property (nonatomic, strong, readonly)
NSMutableDictionary<NSString *, OWLListItem *> *listItems;

@property (nonatomic, strong, readonly)
NSMutableDictionary<NSString *, OWLPropertyBuilder *> *propertyBuilders;

@property (nonatomic, strong, readonly)
NSMutableDictionary<NSString *,NSMutableArray<OWLAxiomBuilder *> *> *singleStatementAxiomBuilders;

@end


@implementation OWLOntologyBuilder

SYNTHESIZE_LAZY_INIT(NSMutableDictionary, allEntityBuilders);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, classExpressionBuilders);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, declarationAxiomBuilders);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, individualBuilders);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, listItems);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, propertyBuilders);
SYNTHESIZE_LAZY_INIT(NSMutableDictionary, singleStatementAxiomBuilders);

#pragma mark OWLAbstractBuilder

- (id<OWLOntology>)build
{
    OWLOntologyID *ontologyID = [[OWLOntologyID alloc] initWithOntologyIRI:nil versionIRI:nil];
    OWLOntologyInternals *internals = [[OWLOntologyInternals alloc] init];
    
    // Declaration axioms
    [self.declarationAxiomBuilders enumerateKeysAndObjectsUsingBlock:^(__unused NSString * _Nonnull key, OWLAxiomBuilder * _Nonnull builder, __unused BOOL * _Nonnull stop)
    {
        @autoreleasepool {
            id<OWLAxiom> axiom = [builder build];
            if (axiom && axiom.axiomType == OWLAxiomTypeDeclaration) {
                [internals addAxiom:axiom];
            }
        }
    }];
    
    // Single statement axioms
    [self.singleStatementAxiomBuilders enumerateKeysAndObjectsUsingBlock:^(__unused NSString * _Nonnull key, NSMutableArray<OWLAxiomBuilder *> * _Nonnull axiomBuilders, __unused BOOL * _Nonnull stop)
    {
        @autoreleasepool {
            for (OWLAxiomBuilder *builder in axiomBuilders) {
                
                id<OWLAxiom> axiom = [builder build];
                if (axiom) {
                    [internals addAxiom:axiom];
                }
            }
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

- (OWLClassExpressionBuilder *)ensureClassExpressionBuilderForID:(NSString *)ID
{
    NSMutableDictionary *classExpressionBuilders = self.classExpressionBuilders;
    OWLClassExpressionBuilder *ceb = classExpressionBuilders[ID];
    
    if (!ceb) {
        ceb = [[OWLClassExpressionBuilder alloc] initWithOntologyBuilder:self];
        setEntityBuilder(self.allEntityBuilders, classExpressionBuilders, ID, ceb);
    }
    
    return ceb;
}

- (OWLClassExpressionBuilder *)classExpressionBuilderForID:(NSString *)ID
{
    return self.classExpressionBuilders[ID];
}

- (OWLIndividualBuilder *)ensureIndividualBuilderForID:(NSString *)ID
{
    NSMutableDictionary *individualBuilders = self.individualBuilders;
    OWLIndividualBuilder *ib = individualBuilders[ID];
    
    if (!ib) {
        ib = [[OWLIndividualBuilder alloc] init];
        setEntityBuilder(self.allEntityBuilders, individualBuilders, ID, ib);
    }
    
    return ib;
}

- (OWLIndividualBuilder *)individualBuilderForID:(NSString *)ID
{
    return self.individualBuilders[ID];
}

- (OWLPropertyBuilder *)ensurePropertyBuilderForID:(NSString *)ID
{
    NSMutableDictionary *propertyBuilders = self.propertyBuilders;
    OWLPropertyBuilder *pb = propertyBuilders[ID];
    
    if (!pb) {
        pb = [[OWLPropertyBuilder alloc] init];
        setEntityBuilder(self.allEntityBuilders, propertyBuilders, ID, pb);
    }
    
    return pb;
}

- (OWLPropertyBuilder *)propertyBuilderForID:(NSString *)ID
{
    return self.propertyBuilders[ID];
}

#pragma mark Axiom builder accessor methods

- (OWLAxiomBuilder *)ensureDeclarationAxiomBuilderForID:(NSString *)ID
{
    NSMutableDictionary *declarationAxiomBuilders = self.declarationAxiomBuilders;
    OWLAxiomBuilder *ab = declarationAxiomBuilders[ID];
    
    if (!ab) {
        ab = [[OWLAxiomBuilder alloc] initWithOntologyBuilder:self];
        declarationAxiomBuilders[ID] = ab;
    }
    
    return ab;
}

- (OWLAxiomBuilder *)declarationAxiomBuilderForID:(NSString *)ID
{
    return self.declarationAxiomBuilders[ID];
}

- (OWLAxiomBuilder *)addSingleStatementAxiomBuilderForID:(NSString *)ID
{
    OWLAxiomBuilder *ab = [self addSingleStatementAxiomBuilderForID:ID ensureUniqueType:OWLABTypeUnknown];
    return ab;
}

- (OWLAxiomBuilder *)addSingleStatementAxiomBuilderForID:(NSString *)ID ensureUniqueType:(OWLABType)uniqueType
{
    NSMutableDictionary *singleStatementAxiomBuilders = self.singleStatementAxiomBuilders;
    NSMutableArray *axiomBuilders = singleStatementAxiomBuilders[ID];
    
    if (!axiomBuilders) {
        axiomBuilders = [[NSMutableArray alloc] init];
        singleStatementAxiomBuilders[ID] = axiomBuilders;
    }
    
    BOOL insert = YES;
    
    if (uniqueType != OWLABTypeUnknown) {
        for (OWLAxiomBuilder *ab in axiomBuilders) {
            if (ab.type == uniqueType) {
                insert = NO;
                break;
            }
        }
    }
    
    OWLAxiomBuilder *ab = nil;
    
    if (insert) {
        ab = [[OWLAxiomBuilder alloc] initWithOntologyBuilder:self];
        
        if (uniqueType != OWLABTypeUnknown) {
            [ab setType:uniqueType error:NULL];
        }
        
        [axiomBuilders addObject:ab];
    }
    
    return ab;
}

#pragma mark Lists

- (OWLListItem *)ensureListItemForID:(NSString *)ID
{
    NSMutableDictionary *listItems = self.listItems;
    OWLListItem *item = listItems[ID];
    
    if (!item) {
        item = [[OWLListItem alloc] init];
        listItems[ID] = item;
    }
    
    return item;
}

- (OWLListItem *)listItemForID:(NSString *)ID
{
    return self.listItems[ID];
}

- (NSArray *)firstItemsForListID:(NSString *)ID
{
    NSDictionary *listItems = self.listItems;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSString *restID = ID;
    
    do {
        OWLListItem *item = listItems[restID];
        NSString *firstID = item.first;
        
        if (firstID) {
            [items addObject:firstID];
        }
        
        restID = item.rest;
    } while (restID);
    
    return items;
}

@end
