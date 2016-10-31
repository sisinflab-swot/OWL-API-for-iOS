//
//  Created by Ivano Bilenchi on 08/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLObjectPropertyExpression.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLObjectPropertyExpression protocol.
@interface OWLObjectPropertyExpressionImpl : OWLObjectImpl

#pragma mark OWLPropertyExpression

@property (nonatomic, readonly) BOOL isDataPropertyExpression;
@property (nonatomic, readonly) BOOL isObjectPropertyExpression;

@end

NS_ASSUME_NONNULL_END
