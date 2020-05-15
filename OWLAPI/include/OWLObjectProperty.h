//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyExpression.h"
#import "OWLIdentifiedEntity.h"
#import "OWLProperty.h"

/// Represents an Object Property in the OWL 2 Specification.
@protocol OWLObjectProperty <OWLObjectPropertyExpression, OWLIdentifiedEntity, OWLProperty> @end
