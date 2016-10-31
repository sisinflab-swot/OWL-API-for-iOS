//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLPropertyExpression.h"
#import "OWLLogicalEntity.h"
#import "OWLNamedObject.h"

/// A marker interface for properties that aren't expression i.e. named properties.
@protocol OWLProperty <OWLPropertyExpression, OWLLogicalEntity, OWLNamedObject> @end
