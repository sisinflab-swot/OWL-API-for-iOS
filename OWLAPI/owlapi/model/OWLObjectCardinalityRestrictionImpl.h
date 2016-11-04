//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLCardinalityRestrictionImpl.h"
#import "OWLObjectCardinalityRestriction.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLObjectCardinalityRestriction protocol.
@interface OWLObjectCardinalityRestrictionImpl : OWLCardinalityRestrictionImpl

#pragma mark OWLObjectCardinalityRestriction

@property (nonatomic, strong, readonly) id<OWLClassExpression> filler;

#pragma mark OWLCardinalityRestriction

@property (nonatomic, readonly) BOOL qualified;

#pragma mark OWLRestriction

@property (nonatomic, strong, readonly) id<OWLObjectPropertyExpression> property;

@property (nonatomic, readonly) BOOL isObjectRestriction;
@property (nonatomic, readonly) BOOL isDataRestriction;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLObjectPropertyExpression>)property filler:(id<OWLClassExpression>)filler cardinality:(NSUInteger)cardinality;

@end

NS_ASSUME_NONNULL_END
