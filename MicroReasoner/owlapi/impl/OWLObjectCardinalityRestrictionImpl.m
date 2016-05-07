//
//  OWLObjectCardinalityRestrictionImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectCardinalityRestrictionImpl.h"

@implementation OWLObjectCardinalityRestrictionImpl

#pragma mark OWLObjectCardinalityRestriction

@dynamic filler;

#pragma mark OWLCardinalityRestriction

- (BOOL)qualified
{
    id<OWLClassExpression> filler = self.filler;
    return filler.anonymous || !filler.isOWLThing;
}

#pragma mark OWLRestriction

- (BOOL)isObjectRestriction { return YES; }

- (BOOL)isDataRestriction { return NO; }

@end
