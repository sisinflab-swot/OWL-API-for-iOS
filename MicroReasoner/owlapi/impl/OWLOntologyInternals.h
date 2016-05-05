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
@protocol OWLSubClassOfAxiom;

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyInternals : NSObject

@property (nonatomic, strong) NSMutableArray<RedlandStatement*> *allStatements;
@property (nonatomic, strong) NSMutableDictionary<NSURL*,id <OWLClass>> *classesByIRI;
@property (nonatomic, strong) NSMutableDictionary<id<OWLClass>,NSSet<id<OWLSubClassOfAxiom>> *> *subClassAxiomsBySubClass;

- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls;

@end

NS_ASSUME_NONNULL_END
