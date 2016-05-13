//
//  OWLOntologyInternalsBuilder.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 13/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RedlandStatement; // TODO: remove
@class OWLOntologyID;

@protocol OWLOntology;

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyBuilder : NSObject

@property (nonatomic, copy) NSURL *ontologyIRI;
@property (nonatomic, copy) NSURL *versionIRI;

- (id<OWLOntology>)buildOWLOntology;

- (void)addStatement:(RedlandStatement *)statement; // TODO: remove
- (void)addClassDeclarationAxiomForIRI:(NSURL *)IRI;
- (void)addObjectPropertyDeclarationAxiomForIRI:(NSURL *)IRI;

@end

NS_ASSUME_NONNULL_END
