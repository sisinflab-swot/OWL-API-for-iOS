//
//  OWLCardinalityRestrictionImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLCardinalityRestrictionImpl.h"

@implementation OWLCardinalityRestrictionImpl

#pragma mark OWLCardinalityRestriction

@synthesize cardinality = _cardinality;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLPropertyExpression>)property
                          filler:(id<OWLPropertyRange>)filler
                     cardinality:(NSUInteger)cardinality
{
    if ((self = [super initWithProperty:property filler:filler])) {
        _cardinality = cardinality;
    }
    return self;
}

@end
