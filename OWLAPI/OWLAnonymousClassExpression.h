//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClassExpression.h"

/**
 * The super interface for all class expressions which are not named class expressions
 * (i.e. all class expressions which are not OWLClass).
 */
@protocol OWLAnonymousClassExpression <OWLClassExpression> @end
