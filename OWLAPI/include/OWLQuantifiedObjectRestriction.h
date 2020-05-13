//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLQuantifiedRestriction.h"
#import "OWLObjectPropertyExpression.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OWLQuantifiedObjectRestriction <OWLQuantifiedRestriction>

#pragma mark OWLRestriction

/// The property/properties that the restriction acts along.
@property (nonatomic, strong, readonly) id<OWLObjectPropertyExpression> property;

#pragma mark OWLQuantifiedRestriction

/// The filler of this restriction.
@property (nonatomic, strong, readonly) id<OWLClassExpression> filler;

@end

NS_ASSUME_NONNULL_END
