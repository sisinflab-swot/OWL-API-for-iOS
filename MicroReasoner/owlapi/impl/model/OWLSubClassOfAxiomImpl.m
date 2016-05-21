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

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equals = NO;
    
    if ([super isEqual:object]) {
        id objCls = [object superClass];
        BOOL sameSuperClass = (objCls == _superClass || [objCls isEqual:_superClass]);
        
        objCls = [object subClass];
        BOOL sameSubClass = (objCls == _subClass || [objCls isEqual:_subClass]);
        
        equals = (sameSuperClass && sameSubClass);
    }
    
    return equals;
}

- (NSUInteger)computeHash { return [_superClass hash] ^ [_subClass hash]; }

- (NSString *)description
{
    return [NSString stringWithFormat:@"SubClassOf(%@ %@)", _subClass, _superClass];
}

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature
{
    // Annotations are not supported right now, so we can just return
    // a set with the signatures of both the superClass and the subClass.
    NSMutableSet *signature = [[NSMutableSet alloc] initWithSet:[_superClass signature]];
    [signature unionSet:[_subClass signature]];
    return signature;
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeSubClassOf; }

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
