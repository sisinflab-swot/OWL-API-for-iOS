//
//  OWLOntologyManager.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OWLOntology;

NS_ASSUME_NONNULL_BEGIN

/**
 * An OWLOntologyManager manages a set of ontologies.
 * It is the main point for creating, loading and accessing ontologies.
 *
 * An OWLOntologyManager also manages the mapping betweem an ontology
 * and its ontology document.
 */
@protocol OWLOntologyManager <NSObject>

/**
 * Loads an ontology from an ontology document contained in a local file.
 * The loaded ontology will be assigned a document IRI that corresponds to the file IRI.
 *
 * @param URL URL of the ontology document to load.
 * @param error NSError out parameter.
 *
 * @return The ontology that was parsed from the file, or nil on error.
 */
- (nullable id<OWLOntology>)loadOntologyFromDocumentAtURL:(NSURL *)URL error:(NSError *__autoreleasing _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
