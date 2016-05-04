//
//  OWLClassExpression.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"

@protocol OWLClass;

NS_ASSUME_NONNULL_BEGIN

/**
 * Represents Class Expressions in the OWL 2 specification.
 * This protocol covers named and anonymous classes.
 */
@protocol OWLClassExpression <OWLObject>

/// Determines whether or not this expression represents an anonymous class expression.
@property (nonatomic, readonly) BOOL anonymous;

/**
 * If this class expression is in fact a named class then this method may be used
 * to obtain the expression as an OWLClass without the need for casting.
 * The general pattern of use is to use 'isAnonymous' to first check.
 *
 * @return This class expression as an OWLClass, or nil on error.
 */
- (nullable id<OWLClass>)asOwlClass;

@end

NS_ASSUME_NONNULL_END
