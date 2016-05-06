//
//  OWLQuantifiedRestrictionImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLRestrictionImpl.h"
#import "OWLQuantifiedRestriction.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLQuantifiedRestriction protocol.
@interface OWLQuantifiedRestrictionImpl : OWLRestrictionImpl

#pragma mark OWLQuantifiedRestriction

@property (nonatomic, strong, readonly) id<OWLPropertyRange> filler;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLPropertyExpression>)property filler:(id<OWLPropertyRange>)filler;

@end

NS_ASSUME_NONNULL_END
