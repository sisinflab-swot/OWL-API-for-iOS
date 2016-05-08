//
//  OWLPropertyExpression.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"

NS_ASSUME_NONNULL_BEGIN

/// Represents a property or possibly the inverse of a property.
@protocol OWLPropertyExpression <OWLObject>

/// Determines if this property expression is anonymous.
@property (nonatomic, readonly) BOOL anonymous;

/// Determines if this property expression is a data property expression.
@property (nonatomic, readonly) BOOL isDataPropertyExpression;

/// Determines if this property expression is an object property expression.
@property (nonatomic, readonly) BOOL isObjectPropertyExpression;

@end

NS_ASSUME_NONNULL_END
