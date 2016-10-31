//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLUnaryPropertyAxiomImpl.h"
#import "OWLPropertyRangeAxiom.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLPropertyRangeAxiom protocol.
@interface OWLPropertyRangeAxiomImpl : OWLUnaryPropertyAxiomImpl

#pragma mark OWLPropertyRangeAxiom

@property (nonatomic, copy, readonly) id<OWLPropertyRange> range;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLPropertyExpression>)property range:(id<OWLPropertyRange>)range;

@end

NS_ASSUME_NONNULL_END
