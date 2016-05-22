//
//  OWLOntologyInternals.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OWLAxiomType.h"

@protocol OWLAxiom;
@protocol OWLClass;
@protocol OWLClassAssertionAxiom;
@protocol OWLClassExpression;
@protocol OWLDisjointClassesAxiom;
@protocol OWLEquivalentClassesAxiom;
@protocol OWLIndividual;
@protocol OWLNamedIndividual;
@protocol OWLObjectProperty;
@protocol OWLObjectPropertyAssertionAxiom;
@protocol OWLSubClassOfAxiom;

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyInternals : NSObject

#pragma mark Mutation methods

- (void)addAxiom:(id<OWLAxiom>)axiom;

#pragma mark Getter methods

- (NSSet<id<OWLClass>> *)allClasses;
- (NSSet<id<OWLNamedIndividual>> *)allNamedIndividuals;
- (NSSet<id<OWLObjectProperty>> *)allObjectProperties;

- (NSSet<id<OWLClassAssertionAxiom>> *)classAssertionAxiomsForIndividual:(id<OWLIndividual>)individual;
- (NSSet<id<OWLDisjointClassesAxiom>> *)disjointClassesAxiomsForClass:(id<OWLClass>)cls;
- (NSSet<id<OWLEquivalentClassesAxiom>> *)equivalentClassesAxiomsForClass:(id<OWLClass>)cls;
- (NSSet<id<OWLObjectPropertyAssertionAxiom>> *)objectPropertyAssertionAxiomsForIndividual:(id<OWLIndividual>)individual;
- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls;

@end

NS_ASSUME_NONNULL_END
