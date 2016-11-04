//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"
#import "OWLPropertyRange.h"
#import "OWLClassExpressionType.h"

@protocol OWLClass;

NS_ASSUME_NONNULL_BEGIN

/**
 * Represents Class Expressions in the OWL 2 specification.
 * This protocol covers named and anonymous classes.
 */
@protocol OWLClassExpression <OWLObject, OWLPropertyRange>

/// The class expression type for this class expression.
@property (nonatomic, readonly) OWLClassExpressionType classExpressionType;

/// Determines whether or not this expression represents an anonymous class expression.
@property (nonatomic, readonly) BOOL anonymous;

/// Determines if this expression is the built in class owl:Thing.
@property (nonatomic, readonly) BOOL isOWLThing;

/// Determines if this expression is the built in class owl:Nothing.
@property (nonatomic, readonly) BOOL isOWLNothing;


/**
 * Interprets this expression as a conjunction and returns the conjuncts.
 *
 * @return The conjucts of this expression if it is a conjunction (object intersection of),
 * or otherwise a set containing this expression.
 */
- (NSSet<id<OWLClassExpression>> *)asConjunctSet;

/**
 * If this class expression is in fact a named class then this method may be used
 * to obtain the expression as an OWLClass without the need for casting.
 * The general pattern of use is to use 'anonymous' to first check.
 *
 * @return This class expression as an OWLClass, or nil on error.
 */
- (nullable id<OWLClass>)asOwlClass;

@end

NS_ASSUME_NONNULL_END
