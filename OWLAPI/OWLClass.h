//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClassExpression.h"
#import "OWLLogicalEntity.h"
#import "OWLNamedObject.h"

@protocol OWLOntology;

NS_ASSUME_NONNULL_BEGIN

/// Represents a Class in the OWL 2 specification.
@protocol OWLClass <OWLClassExpression, OWLLogicalEntity, OWLNamedObject>

/**
 * Gets the class expressions corresponding to disjoint classes of this class.
 *
 * @param ontology The ontology to be examined.
 *
 * @return Disjoint classes of this class.
 */
- (NSSet<id<OWLClassExpression>> *)disjointClassesInOntology:(id<OWLOntology>)ontology;

/**
 * Gets the class expressions corresponding to equivalent classes of this class.
 *
 * @param ontology The ontology to be examined.
 *
 * @return Equivalent classes of this class.
 */
- (NSSet<id<OWLClassExpression>> *)equivalentClassesInOntology:(id<OWLOntology>)ontology;

/**
 * Gets the class expressions corresponding to sub classes of this class.
 *
 * @param ontology The ontology to be examined.
 *
 * @return Sub classes of this class.
 */
- (NSSet<id<OWLClassExpression>> *)subClassesInOntology:(id<OWLOntology>)ontology;

/**
 * Gets the class expressions corresponding to super classes of this class.
 *
 * @param ontology The ontology to be examined.
 *
 * @return Super classes of this class.
 */
- (NSSet<id<OWLClassExpression>> *)superClassesInOntology:(id<OWLOntology>)ontology;

@end

NS_ASSUME_NONNULL_END
