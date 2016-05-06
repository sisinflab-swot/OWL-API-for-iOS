//
//  OWLQuantifiedRestrictionImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLQuantifiedRestrictionImpl.h"

@implementation OWLQuantifiedRestrictionImpl

#pragma mark OWLQuantifiedRestriction

@synthesize filler = _filler;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLPropertyExpression>)property filler:(id<OWLPropertyRange>)filler
{
    NSParameterAssert(filler);
    
    if ((self = [super initWithProperty:property])) {
        _filler = filler;
    }
    return self;
}

@end
