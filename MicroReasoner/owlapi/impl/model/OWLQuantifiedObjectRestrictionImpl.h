//
//  OWLQuantifiedObjectRestrictionImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLQuantifiedRestrictionImpl.h"
#import "OWLObjectPropertyExpression.h"

@protocol OWLObjectPropertyExpression;

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLQuantifiedObjectRestriction protocol.
@interface OWLQuantifiedObjectRestrictionImpl : OWLQuantifiedRestrictionImpl

#pragma mark OWLObjectCardinalityRestriction

@property (nonatomic, strong, readonly) id<OWLClassExpression> filler;

#pragma mark OWLRestriction

@property (nonatomic, strong, readonly) id<OWLObjectPropertyExpression> property;

@property (nonatomic, readonly) BOOL isObjectRestriction;
@property (nonatomic, readonly) BOOL isDataRestriction;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLObjectPropertyExpression>)property filler:(id<OWLClassExpression>)filler;

@end

NS_ASSUME_NONNULL_END
