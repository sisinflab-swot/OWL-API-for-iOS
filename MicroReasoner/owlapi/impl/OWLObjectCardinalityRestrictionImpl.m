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

@dynamic property;

- (BOOL)isObjectRestriction { return YES; }

- (BOOL)isDataRestriction { return NO; }

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLObjectPropertyExpression>)property filler:(id<OWLClassExpression>)filler cardinality:(NSUInteger)cardinality
{
    return [super initWithProperty:property filler:filler cardinality:cardinality];
}

@end
