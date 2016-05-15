//
//  OWLIndividual.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"
#import "OWLPropertyAssertionObject.h"

@protocol OWLClassExpression;
@protocol OWLNamedIndividual;
@protocol OWLOntology;

NS_ASSUME_NONNULL_BEGIN

/// Represents a named or anonymous individual.
@protocol OWLIndividual <OWLObject, OWLPropertyAssertionObject>

/// Determines if this object is an instance of OWLAnonymousIndividual.
@property (nonatomic, readonly) BOOL anonymous;

/// Determines if this object is an instance of OWLNamedIndividual.
@property (nonatomic, readonly) BOOL named;

/**
 * Obtains this individual as a named individual if it is indeed named.
 *
 * @return The individual as a named individual, or nil if it is not named. 
 */
- (id<OWLNamedIndividual>)asOWLNamedIndividual;

/**
 * Convenience method which gets the types of this individual that correspond
 * to the types asserted with axioms in the specified ontology.
 *
 * @param ontology The ontology that should be examined.
 *
 * @return Asserted types of this individual in the specified ontology.
 */
- (NSSet<id<OWLClassExpression>> *)typesInOntology:(id<OWLOntology>)ontology;

@end

NS_ASSUME_NONNULL_END
