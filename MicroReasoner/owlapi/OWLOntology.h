//
//  OWLOntology.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"

@class OWLOntologyID;

NS_ASSUME_NONNULL_BEGIN

/// Represents an OWL 2 Ontology in the OWL 2 specification.
@protocol OWLOntology <OWLObject>

/// The identity of this ontology.
@property (nonatomic, copy, readonly) OWLOntologyID *ontologyID;

@end

NS_ASSUME_NONNULL_END
