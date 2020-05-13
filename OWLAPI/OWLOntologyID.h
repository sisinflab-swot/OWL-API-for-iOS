//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OWLIRI;

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
@property (nonatomic, copy, readonly, nullable) OWLIRI *ontologyIRI;

/// The version IRI of this ontology, or nil if there is no version IRI.
@property (nonatomic, copy, readonly, nullable) OWLIRI *versionIRI;

@end

NS_ASSUME_NONNULL_END
