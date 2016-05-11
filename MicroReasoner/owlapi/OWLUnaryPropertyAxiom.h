//
//  OWLUnaryPropertyAxiom.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLPropertyAxiom.h"

@protocol OWLPropertyExpression;

NS_ASSUME_NONNULL_BEGIN

@protocol OWLUnaryPropertyAxiom <OWLPropertyAxiom>

/// The property expression that this axiom describes.
@property (nonatomic, copy, readonly) id<OWLPropertyExpression> property;

@end

NS_ASSUME_NONNULL_END
