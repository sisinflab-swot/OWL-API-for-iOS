//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLUnaryPropertyAxiom.h"

@protocol OWLClassExpression;

NS_ASSUME_NONNULL_BEGIN

@protocol OWLPropertyDomainAxiom <OWLUnaryPropertyAxiom>

/// The domain specified by this property axiom.
@property (nonatomic, copy, readonly) id<OWLClassExpression> domain;

@end

NS_ASSUME_NONNULL_END
