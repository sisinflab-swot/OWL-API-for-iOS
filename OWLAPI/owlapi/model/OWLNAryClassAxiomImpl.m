//
//  Created by Ivano Bilenchi on 09/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLNAryClassAxiomImpl.h"
#import "OWLClassExpression.h"

@implementation OWLNAryClassAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        NSSet *objCE = ((OWLNAryClassAxiomImpl *)object)->_classExpressions;
        equal = (objCE == _classExpressions || [objCE isEqualToSet:_classExpressions]);
    }
    
    return equal;
}

- (NSUInteger)computeHash
{
    NSUInteger hash = 0;
    
    for (id<OWLClassExpression> ce in _classExpressions) {
        hash ^= [ce hash];
    }
    
    return hash;
}

#pragma mark OWLObject

- (NSMutableSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = nil;
    
    for (id<OWLClassExpression> ce in _classExpressions) {
        if (!signature) {
            signature = [ce signature];
        } else {
            [signature unionSet:[ce signature]];
        }
    }
    
    return signature ?: [NSMutableSet set];
}

#pragma mark OWLNAryClassAxiom

@synthesize classExpressions = _classExpressions;

#pragma mark Other public methods

- (instancetype)initWithClassExpressions:(NSSet<id<OWLClassExpression>> *)classExpressions
{
    NSParameterAssert(classExpressions.count);
    
    if ((self = [super init])) {
        _classExpressions = [classExpressions copy];
    }
    return self;
}

@end
