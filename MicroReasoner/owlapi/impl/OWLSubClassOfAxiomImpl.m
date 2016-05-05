//
//  OWLSubClassOfAxiomImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLSubClassOfAxiomImpl.h"
#import "OWLClassExpression.h"

@implementation OWLSubClassOfAxiomImpl

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature
{
    // Annotations are not supported right now, so we can just return
    // a set with the signatures of both the superClass and the subClass.
    NSMutableSet *signature = [[NSMutableSet alloc] initWithSet:[self.superClass signature]];
    [signature unionSet:[self.subClass signature]];
    return signature;
}

#pragma mark OWLSubClassOfAxiom

@synthesize superClass = _superClass;
@synthesize subClass = _subClass;

#pragma mark Other public methods

- (instancetype)initWithSuperClass:(id<OWLClassExpression>)superClass subClass:(id<OWLClassExpression>)subClass
{
    NSParameterAssert(superClass && subClass);
    
    if ((self = [super init])) {
        _superClass = superClass;
        _subClass = subClass;
    }
    return self;
}

@end
