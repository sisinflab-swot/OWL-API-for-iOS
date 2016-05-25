//
//  OWLAnonymousIndividualImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 25/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAnonymousIndividualImpl.h"
#import "OWLNodeID.h"

@implementation OWLAnonymousIndividualImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    return ([object isKindOfClass:[self class]] && ((OWLAnonymousIndividualImpl *)object)->_ID == _ID);
}

- (NSUInteger)hash { return (NSUInteger)_ID; }

- (NSString *)description { return [NSString stringWithFormat:@"Individual(%@)", OWLNodeID_toString(_ID)]; }

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature { return [NSSet set]; }

#pragma mark OWLIndividual

- (BOOL)anonymous { return YES; }

- (BOOL)named { return NO; }

- (id<OWLNamedIndividual>)asOWLNamedIndividual { return nil; }

#pragma mark OWLAnonymousIndividual

@synthesize ID = _ID;

#pragma mark Other public methods

- (instancetype)initWithNodeID:(OWLNodeID)ID
{
    NSParameterAssert(ID != 0);
    
    if ((self = [super init])) {
        _ID = ID;
    }
    return self;
}

@end
