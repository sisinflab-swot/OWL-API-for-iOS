//
//  Created by Ivano Bilenchi on 25/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLAnonymousIndividualImpl.h"
#import "OWLCowlUtils.h"
#import "OWLNodeID.h"
#import "cowl_anon_ind.h"

@implementation OWLAnonymousIndividualImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (self == object) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_anon_ind_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return (NSUInteger)cowl_anon_ind_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_anon_ind_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler { /* No-op */ }

#pragma mark OWLIndividual

- (BOOL)anonymous { return YES; }

- (BOOL)named { return NO; }

- (id<OWLNamedIndividual>)asOWLNamedIndividual { return nil; }

#pragma mark OWLAnonymousIndividual

- (OWLNodeID)nodeID { return (OWLNodeID)cowl_anon_ind_get_id(_cowlObject); }

#pragma mark Other public methods

- (instancetype)initWithCowlIndividual:(CowlAnonInd *)individual retain:(BOOL)retain {
    NSParameterAssert(individual);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_anon_ind_retain(individual) : individual;
    }
    return self;
}

- (instancetype)initWithNodeID:(OWLNodeID)nodeID {
    NSParameterAssert(nodeID != COWL_NODE_ID_NULL);
    return [self initWithCowlIndividual:cowl_anon_ind_get((CowlNodeID)nodeID) retain:NO];
}

- (void)dealloc { cowl_anon_ind_release(_cowlObject); }

@end
