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
#import "OWLMap.h"
#import "OWLNamedIndividual.h"
#import "OWLOntologyID.h"
#import "OWLOntologyImpl.h"
#import "OWLOntologyInternals.h"
#import "OWLPropertyBuilder.h"
#import "OWLSubClassOfAxiom.h"

@interface OWLOntologyBuilder ()
{
    id<OWLOntology> _builtOntology;
    
    // Entity builders
    OWLMap *_classExpressionBuilders;
    OWLMap *_individualBuilders;
    OWLMap *_propertyBuilders;
    
    // Axiom builders
    OWLMap *_declarationAxiomBuilders;
    NSMutableArray<OWLAxiomBuilder *> *_singleStatementAxiomBuilders;
    
    // Other
    OWLMap *_listItems;
}
@end


@implementation OWLOntologyBuilder

#pragma mark Lifecycle

- (instancetype)init
{
    if ((self = [super init])) {
        _classExpressionBuilders = owl_map_init();
        _individualBuilders = owl_map_init();
        _propertyBuilders = owl_map_init();
        
        _declarationAxiomBuilders = owl_map_init();
        _singleStatementAxiomBuilders = [[NSMutableArray alloc] init];
        
        _listItems = owl_map_init();
    }
    return self;
}

- (void)dealloc
{
    owl_map_dealloc_obj(_classExpressionBuilders);
    _classExpressionBuilders = NULL;
    
    owl_map_dealloc_obj(_individualBuilders);
    _classExpressionBuilders = NULL;
    
    owl_map_dealloc_obj(_propertyBuilders);
    _propertyBuilders = NULL;
    
    owl_map_dealloc_obj(_listItems);
    _listItems = NULL;
    
    owl_map_dealloc_obj(_declarationAxiomBuilders);
    _declarationAxiomBuilders = NULL;
}

#pragma mark OWLAbstractBuilder

- (id<OWLOntology>)build
{
    if (_builtOntology) {
        return _builtOntology;
    }
    
    OWLOntologyInternals *internals = [[OWLOntologyInternals alloc] init];
    
    // Declaration axioms
    owl_map_iterate_and_dealloc_obj(_declarationAxiomBuilders, ^(OWLAxiomBuilder *builder) {
        id<OWLAxiom> axiom = [builder build];
        if (axiom && axiom.axiomType == OWLAxiomTypeDeclaration) {
            [internals addAxiom:axiom];
        }
    });
    _declarationAxiomBuilders = NULL;
    
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
    OWLIRI *ontologyIRI = _ontologyIRI ? [[OWLIRI alloc] initWithString:(NSString *_Nonnull)_ontologyIRI] : nil;
    OWLIRI *versionIRI = _versionIRI ? [[OWLIRI alloc] initWithString:(NSString *_Nonnull)_versionIRI] : nil;
    
    return [[OWLOntologyID alloc] initWithOntologyIRI:ontologyIRI versionIRI:versionIRI];
}

#pragma mark Ontology header

SYNTHESIZE_BUILDER_STRING_PROPERTY(ontologyIRI, OntologyIRI, @"Multiple ontology IRIs for ontology.")
SYNTHESIZE_BUILDER_STRING_PROPERTY(versionIRI, VersionIRI, @"Multiple version IRIs for ontology.")

#pragma mark Entity builders

- (OWLClassExpressionBuilder *)ensureClassExpressionBuilderForID:(unsigned char *)ID
{
    OWLClassExpressionBuilder *ceb = owl_map_get_obj(_classExpressionBuilders, ID);
    
    if (!ceb) {
        ceb = [[OWLClassExpressionBuilder alloc] initWithOntologyBuilder:self];
        owl_map_set_obj(_classExpressionBuilders, ID, ceb);
    }
    
    return ceb;
}

- (OWLClassExpressionBuilder *)classExpressionBuilderForID:(unsigned char *)ID
{
    return owl_map_get_obj(_classExpressionBuilders, ID);
}

- (OWLIndividualBuilder *)ensureIndividualBuilderForID:(unsigned char *)ID
{
    OWLIndividualBuilder *ib = owl_map_get_obj(_individualBuilders, ID);
    
    if (!ib) {
        ib = [[OWLIndividualBuilder alloc] init];
        owl_map_set_obj(_individualBuilders, ID, ib);
    }
    
    return ib;
}

- (OWLIndividualBuilder *)individualBuilderForID:(unsigned char *)ID
{
    return owl_map_get_obj(_individualBuilders, ID);
}

- (OWLPropertyBuilder *)ensurePropertyBuilderForID:(unsigned char *)ID
{
    OWLPropertyBuilder *pb = owl_map_get_obj(_propertyBuilders, ID);
    
    if (!pb) {
        pb = [[OWLPropertyBuilder alloc] init];
        owl_map_set_obj(_propertyBuilders, ID, pb);
    }
    
    return pb;
}

- (OWLPropertyBuilder *)propertyBuilderForID:(unsigned char *)ID
{
    return owl_map_get_obj(_propertyBuilders, ID);
}

#pragma mark Axiom builders

- (OWLAxiomBuilder *)ensureDeclarationAxiomBuilderForID:(unsigned char *)ID
{
    OWLAxiomBuilder *ab = owl_map_get_obj(_declarationAxiomBuilders, ID);
    
    if (!ab) {
        ab = [[OWLAxiomBuilder alloc] initWithOntologyBuilder:self];
        owl_map_set_obj(_declarationAxiomBuilders, ID, ab);
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

- (OWLListItem *)ensureListItemForID:(unsigned char *)ID
{
    OWLListItem *item = owl_map_get_obj(_listItems, ID);
    
    if (!item) {
        item = [[OWLListItem alloc] init];
        owl_map_set_obj(_listItems, ID, item);
    }
    
    return item;
}

- (OWLListItem *)listItemForID:(unsigned char *)ID
{
    return owl_map_get_obj(_listItems, ID);
}

- (void)iterateFirstItemsForListID:(unsigned char *)ID withHandler:(void (^)(unsigned char *firstID))handler
{
    unsigned char *restID = ID;
    
    do {
        OWLListItem *item = owl_map_get_obj(_listItems, restID);
        unsigned char *firstID = item.first;
        
        if (firstID) {
            handler(firstID);
        }
        
        restID = item.rest;
    } while (restID);
}

@end
