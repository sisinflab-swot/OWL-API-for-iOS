//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLIndividual.h"
#import "OWLIdentifiedEntity.h"
#import "OWLLogicalEntity.h"

/// Represents a named individual.
@protocol OWLNamedIndividual <OWLIndividual, OWLIdentifiedEntity, OWLLogicalEntity> @end
