//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLAnonymousClassExpression.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that implements part of the OWLAnonymousClassExpression protocol.
@interface OWLAnonymousClassExpressionImpl : OWLObjectImpl

#pragma mark OWLClassExpression

@property (nonatomic, readonly) BOOL anonymous;
@property (nonatomic, readonly) BOOL isOWLThing;
@property (nonatomic, readonly) BOOL isOWLNothing;

- (NSSet<id<OWLClassExpression>> *)asConjunctSet;
- (nullable id<OWLClass>)asOwlClass;

@end

NS_ASSUME_NONNULL_END
