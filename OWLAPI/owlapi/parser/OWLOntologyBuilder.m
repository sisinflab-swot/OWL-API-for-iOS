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
#import "OWLError.h"
#import "OWLIndividualBuilder.h"
#import "OWLIRI.h"
#import "OWLListItem.h"
#import "OWLNamedIndividual.h"
#import "OWLOntologyID.h"
#import "OWLOntologyImpl.h"
#import "OWLOntologyInternals.h"
#import "OWLPropertyBuilder.h"
#import "OWLSubClassOfAxiom.h"
#import "NSMutableDictionary+SMRMutableDictionaryUtils.h"

@interface OWLOntologyBuilder ()
{
    id<OWLOntology> _builtOntology;
    
    // The keys of these dictionaries are either blank node IDs or IRIs,
    // matching the subject node of the statement that triggered the
    // creation of the builder/item.
    
    // Entity builders
    NSMutableDictionary<NSString *, OWLClassExpressionBuilder *> *_classExpressionBuilders;
    NSMutableDictionary<NSString *, OWLIndividualBuilder *> *_individualBuilders;
    NSMutableDictionary<NSString *, OWLPropertyBuilder *> *_propertyBuilders;
    
    // Axiom builders
    NSMutableDictionary<NSString *, OWLAxiomBuilder *> *_declarationAxiomBuilders;
    NSMutableArray<OWLAxiomBuilder *> *_singleStatementAxiomBuilders;
    
    // Other
    NSMutableDictionary<NSString *, OWLListItem *> *_listItems;
}
@end


@implementation OWLOntologyBuilder

#pragma mark Lifecycle

- (instancetype)init
{
    if ((self = [super init])) {
        _classExpressionBuilders = [[NSMutableDictionary alloc] init];
        _individualBuilders = [[NSMutableDictionary alloc] init];
        _propertyBuilders = [[NSMutableDictionary alloc] init];
        
        _declarationAxiomBuilders = [[NSMutableDictionary alloc] init];
        _singleStatementAxiomBuilders = [[NSMutableArray alloc] init];
        
        _listItems = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark OWLAbstractBuilder

- (id<OWLOntology>)build
{
    if (_builtOntology) {
        return _builtOntology;
    }
    
    OWLOntologyInternals *internals = [[OWLOntologyInternals alloc] init];
    
    // Declaration axioms
    [_declarationAxiomBuilders smr_enumerateAndRemoveKeysAndObjectsUsingBlock:^(__unused id _Nonnull key, OWLAxiomBuilder * _Nonnull builder)
    {
        id<OWLAxiom> axiom = [builder build];
        if (axiom && axiom.axiomType == OWLAxiomTypeDeclaration) {
            [internals addAxiom:axiom];
        }
    }];
    
    // Single statement axioms
    [_singleStatementAxiomBuilders enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(OWLAxiomBuilder * _Nonnull builder, NSUInteger idx, __unused BOOL * _Nonnull stop) {
        id<OWLAxiom> axiom = [builder build];
        if (axiom) {
            [internals addAxiom:axiom];
        }
        [self->_singleStatementAxiomBuilders removeObjectAtIndex:idx];
    }];
    
    id<OWLOntology> onto = [[OWLOntologyImpl alloc] initWithID:[self buildOntologyID] internals:internals];
    
    _builtOntology = onto;
    return onto;
}

- (OWLOntologyID *)buildOntologyID
{
    OWLIRI *ontologyIRI = nil;
    NSString *IRIString = _ontologyIRI;
    
    if (IRIString) {
        ontologyIRI = [[OWLIRI alloc] initWithString:IRIString];
    }
    
    OWLIRI *versionIRI = nil;
    IRIString = _versionIRI;
    
    if (IRIString) {
        versionIRI = [[OWLIRI alloc] initWithString:IRIString];
    }
    
    return [[OWLOntologyID alloc] initWithOntologyIRI:ontologyIRI versionIRI:versionIRI];
}

#pragma mark Ontology header

SYNTHESIZE_BUILDER_STRING_PROPERTY(ontologyIRI, OntologyIRI, @"Multiple ontology IRIs for ontology.")
SYNTHESIZE_BUILDER_STRING_PROPERTY(versionIRI, VersionIRI, @"Multiple version IRIs for ontology.")

#pragma mark Entity builders

- (OWLClassExpressionBuilder *)ensureClassExpressionBuilderForID:(NSString *)ID
{
    NSMutableDictionary *classExpressionBuilders = _classExpressionBuilders;
    OWLClassExpressionBuilder *ceb = classExpressionBuilders[ID];
    
    if (!ceb) {
        ceb = [[OWLClassExpressionBuilder alloc] initWithOntologyBuilder:self];
        classExpressionBuilders[ID] = ceb;
    }
    
    return ceb;
}

- (OWLClassExpressionBuilder *)classExpressionBuilderForID:(NSString *)ID
{
    return _classExpressionBuilders[ID];
}

- (OWLIndividualBuilder *)ensureIndividualBuilderForID:(NSString *)ID
{
    NSMutableDictionary *individualBuilders = _individualBuilders;
    OWLIndividualBuilder *ib = individualBuilders[ID];
    
    if (!ib) {
        ib = [[OWLIndividualBuilder alloc] init];
        individualBuilders[ID] = ib;
    }
    
    return ib;
}

- (OWLIndividualBuilder *)individualBuilderForID:(NSString *)ID
{
    return _individualBuilders[ID];
}

- (OWLPropertyBuilder *)ensurePropertyBuilderForID:(NSString *)ID
{
    NSMutableDictionary *propertyBuilders = _propertyBuilders;
    OWLPropertyBuilder *pb = propertyBuilders[ID];
    
    if (!pb) {
        pb = [[OWLPropertyBuilder alloc] init];
        propertyBuilders[ID] = pb;
    }
    
    return pb;
}

- (OWLPropertyBuilder *)propertyBuilderForID:(NSString *)ID
{
    return _propertyBuilders[ID];
}

#pragma mark Axiom builders

- (OWLAxiomBuilder *)ensureDeclarationAxiomBuilderForID:(NSString *)ID
{
    NSMutableDictionary *declarationAxiomBuilders = _declarationAxiomBuilders;
    OWLAxiomBuilder *ab = declarationAxiomBuilders[ID];
    
    if (!ab) {
        ab = [[OWLAxiomBuilder alloc] initWithOntologyBuilder:self];
        declarationAxiomBuilders[ID] = ab;
    }
    
    return ab;
}

- (OWLAxiomBuilder *)addSingleStatementAxiomBuilder
{
    OWLAxiomBuilder *ab = [[OWLAxiomBuilder alloc] initWithOntologyBuilder:self];
    [_singleStatementAxiomBuilders addObject:ab];
    return ab;
}

#pragma mark Lists

- (OWLListItem *)ensureListItemForID:(NSString *)ID
{
    NSMutableDictionary *listItems = _listItems;
    OWLListItem *item = listItems[ID];
    
    if (!item) {
        item = [[OWLListItem alloc] init];
        listItems[ID] = item;
    }
    
    return item;
}

- (OWLListItem *)listItemForID:(NSString *)ID
{
    return _listItems[ID];
}

- (NSArray *)firstItemsForListID:(NSString *)ID
{
    NSDictionary *listItems = _listItems;
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
