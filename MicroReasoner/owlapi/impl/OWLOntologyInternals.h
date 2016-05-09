//
//  OWLOntologyInternals.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RedlandStatement;

@protocol OWLClass;
@protocol OWLClassExpression;
@protocol OWLDisjointClassesAxiom;
@protocol OWLEquivalentClassesAxiom;
@protocol OWLSubClassOfAxiom;

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyInternals : NSObject

@property (nonatomic, strong) NSMutableArray<RedlandStatement*> *allStatements;
@property (nonatomic, strong) NSMutableDictionary<NSURL*,id<OWLClass>> *classesByIRI;
@property (nonatomic, strong) NSMutableDictionary<id<OWLClass>,NSSet<id<OWLDisjointClassesAxiom>> *> *disjointClassesAxiomsByClass;
@property (nonatomic, strong) NSMutableDictionary<id<OWLClass>,NSSet<id<OWLEquivalentClassesAxiom>> *> *equivalentClassesAxiomsByClass;
@property (nonatomic, strong) NSMutableDictionary<id<OWLClass>,NSSet<id<OWLSubClassOfAxiom>> *> *subClassAxiomsBySubClass;

- (NSSet<id<OWLDisjointClassesAxiom>> *)disjointClassesAxiomsForClass:(id<OWLClass>)cls;
- (NSSet<id<OWLEquivalentClassesAxiom>> *)equivalentClassesAxiomsForClass:(id<OWLClass>)cls;
- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls;

@end

NS_ASSUME_NONNULL_END
