//
//  OWLObjectPropertyExpression.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLPropertyExpression.h"

@protocol OWLObjectProperty;

NS_ASSUME_NONNULL_BEGIN

@protocol OWLObjectPropertyExpression <OWLPropertyExpression>

- (id<OWLObjectProperty>)asOWLObjectProperty;

@end

NS_ASSUME_NONNULL_END
