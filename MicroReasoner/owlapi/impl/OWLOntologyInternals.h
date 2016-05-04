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

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyInternals : NSObject

/// OWL classes by IRI.
@property (nonatomic, strong) NSMutableDictionary<NSURL*, id <OWLClass>> *classesByIRI;

/// Statements in the ontology document.
@property (nonatomic, strong) NSMutableArray<RedlandStatement*> *allStatements;

@end

NS_ASSUME_NONNULL_END
