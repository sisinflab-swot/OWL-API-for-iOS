//
//  Created by Ivano Bilenchi on 22/09/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLBooleanClassExpression.h"

NS_ASSUME_NONNULL_BEGIN

/// Represents an ObjectComplementOf class expression in the OWL 2 Specification.
@protocol OWLObjectComplementOf <OWLBooleanClassExpression>

/// The operand of this class expression.
@property (nonatomic, copy, readonly) id<OWLClassExpression> operand;

@end

NS_ASSUME_NONNULL_END
