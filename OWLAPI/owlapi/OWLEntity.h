//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLNamedObject.h"
#import "OWLEntityType.h"

NS_ASSUME_NONNULL_BEGIN

/// Represents Entities in the OWL 2 Specification.
@protocol OWLEntity <OWLNamedObject>

/// The entity type for this entity.
@property (nonatomic, readonly) OWLEntityType entityType;

/// Determines if this entity is an OWLClass.
@property (nonatomic, readonly) BOOL isOWLClass;

/// Determines if this entity is an OWLNamedIndividual;
@property (nonatomic, readonly) BOOL isOWLNamedIndividual;

/// Determines if this entity is an OWLObjectProperty.
@property (nonatomic, readonly) BOOL isOWLObjectProperty;

@end

NS_ASSUME_NONNULL_END
