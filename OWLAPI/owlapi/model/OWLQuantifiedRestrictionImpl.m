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
        id objFiller = ((OWLQuantifiedRestrictionImpl *)object)->_filler;
        equal = (objFiller == _filler || [objFiller isEqual:_filler]);
    }
    
    return equal;
}

- (NSUInteger)computeHash { return [super computeHash] ^ [_filler hash]; }

#pragma mark OWLObject

- (NSMutableSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [self.property signature];
    [signature unionSet:[_filler signature]];
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
