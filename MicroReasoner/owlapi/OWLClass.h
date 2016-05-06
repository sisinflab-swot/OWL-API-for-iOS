//
//  OWLClass.h
//  MicroReasoner
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
 * A convenience method that examines the axioms in the specified ontology
 * and returns the class expressions corresponding to super classes of this class.
 *
 * @param ontology The ontology to be examined.
 * @return Super classes of this class.
 */
- (NSSet<id<OWLClassExpression>> *)getSuperClassesInOntology:(id<OWLOntology>)ontology;

@end

NS_ASSUME_NONNULL_END
