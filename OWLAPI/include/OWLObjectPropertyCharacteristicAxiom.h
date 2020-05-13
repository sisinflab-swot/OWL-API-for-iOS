//
//  Created by Ivano Bilenchi on 27/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyAxiom.h"
#import "OWLObjectPropertyExpression.h"
#import "OWLUnaryPropertyAxiom.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OWLObjectPropertyCharacteristicAxiom <OWLObjectPropertyAxiom, OWLUnaryPropertyAxiom>

#pragma mark OWLUnaryPropertyAxiom

/// The property expression that this axiom describes.
@property (nonatomic, copy, readonly) id<OWLObjectPropertyExpression> property;

@end

NS_ASSUME_NONNULL_END
