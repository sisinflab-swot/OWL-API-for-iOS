//
//  OWLEntity.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLNamedObject.h"

NS_ASSUME_NONNULL_BEGIN

/// Represents Entities in the OWL 2 Specification.
@protocol OWLEntity <OWLObject, OWLNamedObject>

/// Determines if this entity is an OWLClass.
@property (nonatomic, readonly) BOOL isOWLClass;

@end

NS_ASSUME_NONNULL_END
