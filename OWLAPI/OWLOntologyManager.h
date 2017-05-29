//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OWLDataFactory;
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
 * A data factory which can be used to create OWL API objects such as
 * classes, properties, individuals, axioms etc.
 */
@property (nonatomic, strong, readonly) id<OWLDataFactory> dataFactory;

/**
 * Loads an ontology from an ontology document contained in a local file.
 * The loaded ontology will be assigned a document IRI that corresponds to the file IRI.
 *
 * @param URL URL of the ontology document to load.
 * @param error Error out parameter.
 *
 * @return The ontology that was parsed from the file, or nil on error.
 */
- (nullable id<OWLOntology>)loadOntologyFromDocumentAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
