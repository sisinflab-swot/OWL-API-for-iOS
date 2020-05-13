//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLClassExpression.h"
#import "OWLLogicalEntity.h"
#import "OWLNamedObject.h"

@protocol OWLOntology;

NS_ASSUME_NONNULL_BEGIN

/// Represents a Class in the OWL 2 specification.
@protocol OWLClass <OWLClassExpression, OWLLogicalEntity, OWLNamedObject> @end

NS_ASSUME_NONNULL_END
