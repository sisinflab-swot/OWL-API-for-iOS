//
//  OWLCardinalityRestrictionImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLCardinalityRestrictionImpl.h"
#import "OWLPropertyExpression.h"

@implementation OWLCardinalityRestrictionImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equals = NO;
    
    if ([super isEqual:object]) {
        equals = ([object cardinality] == self.cardinality);
    }
    
    return equals;
}

- (NSUInteger)hash { return [self.property hash] ^ [self.filler hash] ^ self.cardinality; };

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
