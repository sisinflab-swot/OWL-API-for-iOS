//
//  Created by Ivano Bilenchi on 23/05/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import "OWLDLConstruct.h"

@protocol OWLAxiom;
@protocol OWLClassExpression;
@protocol OWLPropertyExpression;

NS_ASSUME_NONNULL_BEGIN

/// A utility class to compute and represent DL expressivity.
@interface OWLDLExpressivityChecker : NSObject

/// The constructs stored in the checker.
@property (nonatomic) OWLDLConstruct constructs;

/// Returns the pruned description logic name derived from the stored constructs.
- (NSString *)descriptionLogicName;

/**
 * Returns the name for a single construct.
 *
 * @param construct The construct.
 */
- (NSString *)nameForConstruct:(OWLDLConstruct)construct;

/// Prunes the stored constructs.
- (void)pruneConstructs;

/**
 * Updates the stored constructs based on a given axiom.
 *
 * @param axiom The axiom.
 * @param recursive The axiom should be visited recursively.
 */
- (void)addConstructsForAxiom:(id<OWLAxiom>)axiom recursive:(BOOL)recursive;

/**
 * Updates the stored constructs based on a given class expression.
 *
 * @param ce The class expression.
 * @param recursive The class expression should be visited recursively.
 */
- (void)addConstructsForClassExpression:(id<OWLClassExpression>)ce recursive:(BOOL)recursive;

/**
 * Updates the stored constructs based on a given property expression.
 *
 * @param pe The property expression.
 */
- (void)addConstructsForPropertyExpression:(id<OWLPropertyExpression>)pe;

@end

NS_ASSUME_NONNULL_END
