//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLPropertyExpression.h"

@protocol OWLObjectProperty;

NS_ASSUME_NONNULL_BEGIN

/// Represents an ObjectPropertyExpression in the OWL 2 specification.
@protocol OWLObjectPropertyExpression <OWLPropertyExpression>

/// This property as a named object property if it is such, or nil.
- (nullable id<OWLObjectProperty>)asOWLObjectProperty;

@end

NS_ASSUME_NONNULL_END
