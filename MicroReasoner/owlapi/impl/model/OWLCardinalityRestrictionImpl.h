//
//  OWLCardinalityRestrictionImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLQuantifiedRestrictionImpl.h"
#import "OWLCardinalityRestriction.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLCardinalityRestriction protocol.
@interface OWLCardinalityRestrictionImpl : OWLQuantifiedRestrictionImpl

#pragma mark OWLCardinalityRestriction

@property (nonatomic, readonly) NSUInteger cardinality;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLPropertyExpression>)property
                          filler:(id<OWLPropertyRange>)filler
                     cardinality:(NSUInteger)cardinality;

@end

NS_ASSUME_NONNULL_END
