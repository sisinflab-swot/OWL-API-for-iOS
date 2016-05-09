//
//  OWLQuantifiedObjectRestrictionImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLQuantifiedObjectRestrictionImpl.h"
#import "OWLObjectPropertyExpression.h"

@implementation OWLQuantifiedObjectRestrictionImpl

#pragma mark OWLObjectCardinalityRestriction

@dynamic filler;

#pragma mark OWLRestriction

@dynamic property;

- (BOOL)isObjectRestriction { return YES; }

- (BOOL)isDataRestriction { return NO; }

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLObjectPropertyExpression>)property filler:(id<OWLClassExpression>)filler
{
    return [super initWithProperty:property filler:filler];
}

@end
