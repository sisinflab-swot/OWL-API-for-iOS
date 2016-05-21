//
//  OWLNAryClassAxiomImpl.m
//  MicroReasoner
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
        NSSet *objCE = [object classExpressions];
        NSSet *selfCE = self.classExpressions;
        
        equal = (objCE == selfCE || [objCE isEqualToSet:selfCE]);
    }
    
    return equal;
}

- (NSUInteger)computeHash { return self.classExpressions.hash; }

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [[NSMutableSet alloc] init];
    
    for (id<OWLClassExpression> ce in self.classExpressions) {
        [signature unionSet:ce.signature];
    }
    
    return signature;
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
