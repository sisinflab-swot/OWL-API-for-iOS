//
//  OWLSubClassOfAxiomImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLSubClassOfAxiomImpl.h"
#import "OWLClassExpression.h"
#import "NSMapTable+SMRObjectCache.h"

@implementation OWLSubClassOfAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object { return object == self; }

- (NSUInteger)hash { return (NSUInteger)self; }

- (NSString *)description
{
    return [NSString stringWithFormat:@"SubClassOf(%@ %@)", _subClass, _superClass];
}

#pragma mark OWLObject

- (NSMutableSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [_superClass signature];
    [signature unionSet:[_subClass signature]];
    return signature;
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeSubClassOf; }

#pragma mark OWLSubClassOfAxiom

@synthesize superClass = _superClass;
@synthesize subClass = _subClass;

#pragma mark Other public methods

static NSMapTable *instanceCache = nil;

+ (void)initialize
{
    if (self == [OWLSubClassOfAxiomImpl class]) {
        instanceCache = [NSMapTable smr_objCache];
    }
}

- (instancetype)initWithSuperClass:(id<OWLClassExpression>)superClass subClass:(id<OWLClassExpression>)subClass
{
    NSParameterAssert(superClass && subClass);
    
    id cachedInstance = [instanceCache smr_objCacheGetForKey1:superClass key2:subClass];
    
    if (cachedInstance) {
        self = cachedInstance;
    } else if ((self = [super init])) {
        _superClass = [(id)superClass copy];
        _subClass = [(id)subClass copy];
        [instanceCache smr_objCacheSet:self forKey1:_superClass key2:_subClass];
    }
    return self;
}

- (void)dealloc { [instanceCache smr_objCacheRemoveForKey1:_superClass key2:_subClass]; }

@end
