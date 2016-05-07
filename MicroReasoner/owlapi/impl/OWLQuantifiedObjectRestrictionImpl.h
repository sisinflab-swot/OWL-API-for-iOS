//
//  OWLQuantifiedObjectRestrictionImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLQuantifiedRestrictionImpl.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLQuantifiedObjectRestriction protocol.
@interface OWLQuantifiedObjectRestrictionImpl : OWLQuantifiedRestrictionImpl

#pragma mark OWLRestriction

@property (nonatomic, readonly) BOOL isObjectRestriction;
@property (nonatomic, readonly) BOOL isDataRestriction;

@end

NS_ASSUME_NONNULL_END
