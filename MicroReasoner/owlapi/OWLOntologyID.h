//
//  OWLOntologyID.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * An object that identifies an ontology. Since OWL 2, ontologies do not have
 * to have an ontology IRI, or if they have an ontology IRI then they can optionally
 * also have a version IRI. Instances of this OWLOntologyID class bundle identifying
 * information of an ontology together. If an ontology doesn't have an ontology IRI
 * then we say that it is "anonymous".
 */
@interface OWLOntologyID : NSObject <NSCopying>

/// The ontology IRI, or nil if there is no ontology IRI.
@property (nonatomic, copy, readonly, nullable) NSURL *ontologyIRI;

/**
 * Constructs an ontology identifier specifying the ontology IRI.
 *
 * @param ontologyIRI The IRI of the ontology document.
 */
- (instancetype)initWithOntologyIRI:(nullable NSURL *)ontologyIRI;

@end

NS_ASSUME_NONNULL_END
