//
//  OWLRestrictionImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAnonymousClassExpressionImpl.h"
#import "OWLRestriction.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLRestriction protocol.
@interface OWLRestrictionImpl : OWLAnonymousClassExpressionImpl

#pragma mark OWLRestriction

@property (nonatomic, strong, readonly) id<OWLPropertyExpression> property;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLPropertyExpression>)property;

@end

NS_ASSUME_NONNULL_END
