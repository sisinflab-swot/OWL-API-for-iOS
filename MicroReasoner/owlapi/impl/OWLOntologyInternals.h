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
@protocol OWLClassExpression;
@protocol OWLDisjointClassesAxiom;
@protocol OWLEquivalentClassesAxiom;
@protocol OWLObjectProperty;
@protocol OWLSubClassOfAxiom;

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyInternals : NSObject

#pragma mark Mutation methods

- (void)addAxiom:(id<OWLAxiom>)axiom ofType:(OWLAxiomType)type;
- (void)addAxiom:(id<OWLAxiom>)axiom forClass:(id<OWLClass>)cls;
- (void)addAxiom:(id<OWLAxiom>)axiom forObjectProperty:(id<OWLObjectProperty>)property;

#pragma mark Getter methods

- (NSSet<id<OWLClass>> *)allClasses;
- (NSSet<id<OWLObjectProperty>> *)allObjectProperties;

- (NSSet<id<OWLDisjointClassesAxiom>> *)disjointClassesAxiomsForClass:(id<OWLClass>)cls;
- (NSSet<id<OWLEquivalentClassesAxiom>> *)equivalentClassesAxiomsForClass:(id<OWLClass>)cls;
- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls;

@end

NS_ASSUME_NONNULL_END
