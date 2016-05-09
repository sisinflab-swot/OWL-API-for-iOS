//
//  OWLQuantifiedRestrictionImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLQuantifiedRestrictionImpl.h"
#import "OWLPropertyExpression.h"

@implementation OWLQuantifiedRestrictionImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        id objFiller = [object filler];
        id selfFiller = self.filler;
        
        equal = (objFiller == selfFiller || [objFiller isEqual:selfFiller]);
    }
    
    return equal;
}

- (NSUInteger)hash { return [self.property hash] ^ [self.filler hash]; }

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [[NSMutableSet alloc] initWithSet:[self.property signature]];
    [signature unionSet:[self.filler signature]];
    return signature;
}

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
