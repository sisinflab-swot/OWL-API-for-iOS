//
//  OWLOntology.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"

@class OWLOntologyID;
@protocol OWLSubClassOfAxiom;

NS_ASSUME_NONNULL_BEGIN

/// Represents an OWL 2 Ontology in the OWL 2 specification.
@protocol OWLOntology <OWLObject>

/// The identity of this ontology.
@property (nonatomic, copy, readonly) OWLOntologyID *ontologyID;

/**
 * Gets all of the subclass axioms where the left hand side (the subclass)
 * is equal to the specified class.
 *
 * @param cls The class.
 *
 * @return SubClass axioms where the LHS is cls.
 */
- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id <OWLClass>)cls;

@end

NS_ASSUME_NONNULL_END
