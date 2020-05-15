//
//  Created by Ivano Bilenchi on 29/05/17.
//  Copyright © 2017-2020 SisInf Lab. All rights reserved.
//

#import "OWLDataFactoryImpl.h"
#import "OWLAnonymousIndividualImpl.h"
#import "OWLClassAssertionAxiomImpl.h"
#import "OWLClassImpl.h"
#import "OWLDeclarationAxiomImpl.h"
#import "OWLNamedIndividualImpl.h"
#import "OWLNAryBooleanClassExpressionImpl.h"
#import "OWLNAryClassAxiomImpl.h"
#import "OWLObjectCardinalityRestrictionImpl.h"
#import "OWLObjectComplementOfImpl.h"
#import "OWLObjectPropertyAssertionAxiomImpl.h"
#import "OWLObjectPropertyCharacteristicAxiomImpl.h"
#import "OWLObjectPropertyDomainAxiomImpl.h"
#import "OWLObjectPropertyImpl.h"
#import "OWLObjectPropertyRangeAxiomImpl.h"
#import "OWLQuantifiedObjectRestrictionImpl.h"
#import "OWLRDFVocabulary.h"
#import "OWLSubClassOfAxiomImpl.h"

@implementation OWLDataFactoryImpl

#pragma mark OWLDataFactory

- (id<OWLClass>)thing {
    return [[OWLClassImpl alloc] initWithIRI:OWLRDFVocabulary.OWLThing.IRI];
}

- (id<OWLClass>)nothing {
    return [[OWLClassImpl alloc] initWithIRI:OWLRDFVocabulary.OWLNothing.IRI];
}

- (id<OWLObjectProperty>)topObjectProperty {
    return [[OWLObjectPropertyImpl alloc] initWithIRI:OWLRDFVocabulary.OWLTopObjectProperty.IRI];
}

- (id<OWLObjectProperty>)bottomObjectProperty {
    return [[OWLObjectPropertyImpl alloc] initWithIRI:OWLRDFVocabulary.OWLBottomObjectProperty.IRI];
}

- (id<OWLEntity>)entityWithType:(OWLEntityType)type iri:(OWLIRI *)iri {
    switch (type) {
        case OWLEntityTypeClass:
            return [self classWithIRI:iri];
            
        case OWLEntityTypeNamedIndividual:
            return [self namedIndividualWithIRI:iri];
            
        case OWLEntityTypeObjectProperty:
            return [self objectPropertyWithIRI:iri];
            
        default:
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:@"Unsupported entity type."
                                         userInfo:@{@"type": @(type), @"iri": iri}];
    }
}

- (id<OWLClass>)classWithIRI:(OWLIRI *)iri {
    return [[OWLClassImpl alloc] initWithIRI:iri];
}

- (id<OWLObjectProperty>)objectPropertyWithIRI:(OWLIRI *)iri {
    return [[OWLObjectPropertyImpl alloc] initWithIRI:iri];
}

- (id<OWLNamedIndividual>)namedIndividualWithIRI:(OWLIRI *)iri {
    return [[OWLNamedIndividualImpl alloc] initWithIRI:iri];
}

- (id<OWLAnonymousIndividual>)anonymousIndividual {
    return [self anonymousIndividualWithNodeID:OWLNodeID_new()];
}

- (id<OWLAnonymousIndividual>)anonymousIndividualWithNodeID:(OWLNodeID)nodeID {
    return [[OWLAnonymousIndividualImpl alloc] initWithNodeID:nodeID];
}

- (id<OWLClass>)classWithEntityID:(OWLEntityID)entityID {
    return [[OWLClassImpl alloc] initWithCowlClass:(CowlClass *)entityID retain:YES];
}

- (id<OWLNamedIndividual>)namedIndividualWithEntityID:(OWLEntityID)entityID {
    return [[OWLNamedIndividualImpl alloc] initWithCowlNamedInd:(CowlNamedInd *)entityID retain:YES];
}

- (id<OWLObjectProperty>)objectPropertyWithEntityID:(OWLEntityID)entityID {
    return [[OWLObjectPropertyImpl alloc] initWithCowlProperty:(CowlObjProp *)entityID retain:YES];
}

- (id<OWLObjectComplementOf>)objectComplementOf:(id<OWLClassExpression>)classExpression {
    return [[OWLObjectComplementOfImpl alloc] initWithOperand:classExpression];
}

- (id<OWLObjectIntersectionOf>)objectIntersectionOf:(NSSet<id<OWLClassExpression>> *)classExpressions {
    return [[OWLNAryBooleanClassExpressionImpl alloc] initIntersection:classExpressions];
}

- (id<OWLObjectAllValuesFrom>)objectAllValuesFrom:(id<OWLObjectPropertyExpression>)property
                                           filler:(id<OWLClassExpression>)filler {
    return [[OWLQuantifiedObjectRestrictionImpl alloc] initUniversalWithProperty:property
                                                                          filler:filler];
}

- (id<OWLObjectSomeValuesFrom>)objectSomeValuesFrom:(id<OWLObjectPropertyExpression>)property
                                             filler:(id<OWLClassExpression>)filler {
    return [[OWLQuantifiedObjectRestrictionImpl alloc] initExsistentialWithProperty:property
                                                                             filler:filler];
}

- (id<OWLObjectExactCardinality>)objectExactCardinality:(id<OWLObjectPropertyExpression>)property
                                            cardinality:(NSUInteger)cardinality {
    return [self objectExactCardinality:property cardinality:cardinality filler:[self thing]];
}

- (id<OWLObjectExactCardinality>)objectExactCardinality:(id<OWLObjectPropertyExpression>)property
                                            cardinality:(NSUInteger)cardinality
                                                 filler:(id<OWLClassExpression>)filler {
    return [[OWLObjectCardinalityRestrictionImpl alloc] initExactCardinalityWithProperty:property
                                                                                  filler:filler
                                                                             cardinality:cardinality];
}

- (id<OWLObjectMaxCardinality>)objectMaxCardinality:(id<OWLObjectPropertyExpression>)property
                                        cardinality:(NSUInteger)cardinality {
    return [self objectMaxCardinality:property cardinality:cardinality filler:[self thing]];
}

- (id<OWLObjectMaxCardinality>)objectMaxCardinality:(id<OWLObjectPropertyExpression>)property
                                        cardinality:(NSUInteger)cardinality
                                             filler:(id<OWLClassExpression>)filler {
    return [[OWLObjectCardinalityRestrictionImpl alloc] initMaxCardinalityWithProperty:property
                                                                                filler:filler
                                                                           cardinality:cardinality];
}

- (id<OWLObjectMinCardinality>)objectMinCardinality:(id<OWLObjectPropertyExpression>)property
                                        cardinality:(NSUInteger)cardinality {
    return [self objectMinCardinality:property cardinality:cardinality filler:[self thing]];
}

- (id<OWLObjectMinCardinality>)objectMinCardinality:(id<OWLObjectPropertyExpression>)property
                                        cardinality:(NSUInteger)cardinality
                                             filler:(id<OWLClassExpression>)filler {
    return [[OWLObjectCardinalityRestrictionImpl alloc] initMinCardinalityWithProperty:property
                                                                                filler:filler
                                                                           cardinality:cardinality];
}

- (id<OWLDeclarationAxiom>)declarationAxiom:(id<OWLEntity>)entity {
    return [[OWLDeclarationAxiomImpl alloc] initWithEntity:entity];
}

- (id<OWLSubClassOfAxiom>)subClassOfAxiom:(id<OWLClassExpression>)superClass
                                 subClass:(id<OWLClassExpression>)subClass {
    return [[OWLSubClassOfAxiomImpl alloc] initWithSuperClass:superClass subClass:subClass];
}

- (id<OWLDisjointClassesAxiom>)disjointClassesAxiom:(NSSet<id<OWLClassExpression>> *)classExpressions {
    return [[OWLNAryClassAxiomImpl alloc] initWithDisjointClasses:classExpressions];
}

- (id<OWLEquivalentClassesAxiom>)equivalentClassesAxiom:(NSSet<id<OWLClassExpression>> *)classExpressions {
    return [[OWLNAryClassAxiomImpl alloc] initWithEquivalentClasses:classExpressions];
}

- (id<OWLClassAssertionAxiom>)classAssertionAxiom:(id<OWLIndividual>)individual
                                  classExpression:(id<OWLClassExpression>)classExpression {
    return [[OWLClassAssertionAxiomImpl alloc] initWithIndividual:individual classExpression:classExpression];
}

- (id<OWLObjectPropertyAssertionAxiom>)objectPropertyAssertionAxiom:(id<OWLIndividual>)subject
                                                           property:(id<OWLObjectPropertyExpression>)property
                                                             object:(id<OWLIndividual>)object {
    return [[OWLObjectPropertyAssertionAxiomImpl alloc] initWithSubject:subject property:property object:object];
}

- (id<OWLObjectPropertyDomainAxiom>)objectPropertyDomainAxiom:(id<OWLObjectPropertyExpression>)property
                                                       domain:(id<OWLClassExpression>)domain {
    return [[OWLObjectPropertyDomainAxiomImpl alloc] initWithProperty:property domain:domain];
}

- (id<OWLObjectPropertyRangeAxiom>)objectPropertyRangeAxiom:(id<OWLObjectPropertyExpression>)property
                                                      range:(id<OWLClassExpression>)range {
    return [[OWLObjectPropertyRangeAxiomImpl alloc] initWithProperty:property range:range];
}

- (id<OWLTransitiveObjectPropertyAxiom>)transitiveObjectPropertyAxiom:(id<OWLObjectPropertyExpression>)property {
    return [[OWLObjectPropertyCharacteristicAxiomImpl alloc] initTransitiveObjectProperty:property];
}

@end
