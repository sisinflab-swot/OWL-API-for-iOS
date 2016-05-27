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
#import "OWLError.h"
#import "OWLIndividualBuilder.h"
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
    
    NSString *_ontologyIRI;
    NSString *_versionIRI;
    
    // The keys of these dictionaries are either blank node IDs or IRIs,
    // matching the subject node of the statement that triggered the
    // creation of the builder/item.
    
    // Entity builders
    NSMutableDictionary<NSString *, OWLClassExpressionBuilder *> *_classExpressionBuilders;
    NSMutableDictionary<NSString *, OWLIndividualBuilder *> *_individualBuilders;
    NSMutableDictionary<NSString *, OWLPropertyBuilder *> *_propertyBuilders;
    
    // Built entities
    NSMutableDictionary<NSString *, id<OWLClassExpression>> *_builtClassExpressions;
    NSMutableDictionary<NSString *, id<OWLIndividual>> *_builtIndividuals;
    NSMutableDictionary<NSString *, id<OWLPropertyExpression>> *_builtProperties;
    
    // Axiom builders
    NSMutableDictionary<NSString *, OWLAxiomBuilder *> *_declarationAxiomBuilders;
    NSMutableDictionary<NSString *,NSMutableArray<OWLAxiomBuilder *> *> *_singleStatementAxiomBuilders;
    
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
        
        _builtClassExpressions = [[NSMutableDictionary alloc] init];
        _builtIndividuals = [[NSMutableDictionary alloc] init];
        _builtProperties = [[NSMutableDictionary alloc] init];
        
        _declarationAxiomBuilders = [[NSMutableDictionary alloc] init];
        _singleStatementAxiomBuilders = [[NSMutableDictionary alloc] init];
        
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
    [_singleStatementAxiomBuilders smr_enumerateAndRemoveKeysAndObjectsUsingBlock:^(__unused id _Nonnull key, NSMutableArray<OWLAxiomBuilder *> * _Nonnull axiomBuilders)
    {
        for (OWLAxiomBuilder *builder in axiomBuilders) {
            
            id<OWLAxiom> axiom = [builder build];
            if (axiom) {
                [internals addAxiom:axiom];
            }
        }
    }];
    
    id<OWLOntology> onto = [[OWLOntologyImpl alloc] initWithID:[self buildOntologyID] internals:internals];
    
    _builtOntology = onto;
    return onto;
}

- (OWLOntologyID *)buildOntologyID
{
    NSURL *ontologyIRI = nil;
    NSString *IRIString = _ontologyIRI;
    
    if (IRIString) {
        ontologyIRI = [[NSURL alloc] initWithString:IRIString];
    }
    
    NSURL *versionIRI = nil;
    IRIString = _versionIRI;
    
    if (IRIString) {
        versionIRI = [[NSURL alloc] initWithString:IRIString];
    }
    
    return [[OWLOntologyID alloc] initWithOntologyIRI:ontologyIRI versionIRI:versionIRI];
}

#pragma mark Ontology header

- (BOOL)setOntologyIRI:(NSString *)IRI error:(NSError *__autoreleasing  _Nullable *)error
{
    if (_ontologyIRI == IRI || [_ontologyIRI isEqualToString:IRI]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_ontologyIRI) {
        _ontologyIRI = [IRI copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple ontology IRIs for ontology."
                                  userInfo:@{@"IRIs": @[_ontologyIRI, IRI]}];
    }
    
    return success;
}

- (BOOL)setVersionIRI:(NSString *)IRI error:(NSError *__autoreleasing  _Nullable *)error
{
    if (_versionIRI == IRI || [_versionIRI isEqualToString:IRI]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_versionIRI) {
        _versionIRI = [IRI copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple version IRIs for ontology."
                                  userInfo:@{@"IRIs": @[_versionIRI, IRI]}];
    }
    
    return success;
}

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

#pragma mark Built entities

- (id<OWLClassExpression>)classExpressionForID:(NSString *)ID
{
    NSMutableDictionary *builtClassExpressions = _builtClassExpressions;
    id<OWLClassExpression> ce = builtClassExpressions[ID];
    
    if (!ce) {
        NSMutableDictionary *classExpressionBuilders = _classExpressionBuilders;
        ce = [(OWLClassExpressionBuilder *)classExpressionBuilders[ID] build];
        if (ce) {
            builtClassExpressions[ID] = ce;
            [classExpressionBuilders removeObjectForKey:ID];
        }
    }
    
    return ce;
}

- (id<OWLIndividual>)individualForID:(NSString *)ID
{
    NSMutableDictionary *builtIndividuals = _builtIndividuals;
    id<OWLIndividual> ind = builtIndividuals[ID];
    
    if (!ind) {
        NSMutableDictionary *individualBuilders = _individualBuilders;
        ind = [(OWLIndividualBuilder *)individualBuilders[ID] build];
        if (ind) {
            builtIndividuals[ID] = ind;
            [individualBuilders removeObjectForKey:ID];
        }
    }
    
    return ind;
}

- (id<OWLPropertyExpression>)propertyForID:(NSString *)ID
{
    NSMutableDictionary *builtProperties = _builtProperties;
    id<OWLPropertyExpression> pro = builtProperties[ID];
    
    if (!pro) {
        NSMutableDictionary *propertyBuilders = _propertyBuilders;
        pro = [(OWLPropertyBuilder *)propertyBuilders[ID] build];
        if (pro) {
            builtProperties[ID] = pro;
            [propertyBuilders removeObjectForKey:ID];
        }
    }
    
    return pro;
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

- (OWLAxiomBuilder *)declarationAxiomBuilderForID:(NSString *)ID
{
    return _declarationAxiomBuilders[ID];
}

- (OWLAxiomBuilder *)addSingleStatementAxiomBuilderForID:(NSString *)ID
{
    NSMutableDictionary *singleStatementAxiomBuilders = _singleStatementAxiomBuilders;
    NSMutableArray *axiomBuilders = singleStatementAxiomBuilders[ID];
    
    if (!axiomBuilders) {
        axiomBuilders = [[NSMutableArray alloc] init];
        singleStatementAxiomBuilders[ID] = axiomBuilders;
    }
    
    OWLAxiomBuilder *ab = [[OWLAxiomBuilder alloc] initWithOntologyBuilder:self];
    [axiomBuilders addObject:ab];
    
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
