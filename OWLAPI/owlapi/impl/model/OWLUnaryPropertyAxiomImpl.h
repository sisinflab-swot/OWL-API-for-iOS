//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLLogicalAxiomImpl.h"
#import "OWLUnaryPropertyAxiom.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLUnaryPropertyAxiom protocol.
@interface OWLUnaryPropertyAxiomImpl : OWLLogicalAxiomImpl

#pragma mark OWLUnaryPropertyAxiom

@property (nonatomic, copy, readonly) id<OWLPropertyExpression> property;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLPropertyExpression>)property;

@end

NS_ASSUME_NONNULL_END
