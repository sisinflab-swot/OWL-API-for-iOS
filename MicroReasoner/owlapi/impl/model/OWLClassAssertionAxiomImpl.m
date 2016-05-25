//
//  OWLClassAssertionAxiomImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClassAssertionAxiomImpl.h"
#import "OWLClassExpression.h"
#import "OWLIndividual.h"
#import "NSMapTable+SMRObjectCache.h"

@implementation OWLClassAssertionAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object { return object == self; }

- (NSUInteger)hash { return (NSUInteger)self; }

- (NSString *)description
{
    return [NSString stringWithFormat:@"ClassAssertion(%@ %@)", _classExpression, _individual];
}

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [[NSMutableSet alloc] initWithSet:[_individual signature]];
    [signature unionSet:[_classExpression signature]];
    return signature;
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeClassAssertion; }

#pragma mark OWLClassAssertionAxiom

@synthesize individual = _individual;
@synthesize classExpression = _classExpression;

#pragma mark Other public methods

static NSMapTable *instanceCache = nil;

+ (void)initialize
{
    if (self == [OWLClassAssertionAxiomImpl class]) {
        instanceCache = [NSMapTable smr_objCache];
    }
}

- (instancetype)initWithIndividual:(id<OWLIndividual>)individual classExpression:(id<OWLClassExpression>)classExpression
{
    NSParameterAssert(individual && classExpression);
    
    id cachedInstance = [instanceCache smr_objCacheGetForKey1:individual key2:classExpression];
    
    if (cachedInstance) {
        self = cachedInstance;
    } else if ((self = [super init])) {
        _individual = [(id)individual copy];
        _classExpression = [(id)classExpression copy];
        
        [instanceCache smr_objCacheSet:self forKey1:_individual key2:_classExpression];
    }
    return self;
}

- (void)dealloc { [instanceCache smr_objCacheRemoveForKey1:_individual key2:_classExpression]; }

@end
