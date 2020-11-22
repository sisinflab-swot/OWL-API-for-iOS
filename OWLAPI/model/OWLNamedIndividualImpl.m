//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLNamedIndividualImpl.h"
#import "OWLCowlUtils.h"
#import "OWLIRI+Private.h"

#import <cowl_named_ind.h>

@implementation OWLNamedIndividualImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_named_ind_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return (NSUInteger)cowl_named_ind_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_named_ind_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    handler(self);
}

- (NSSet<id<OWLEntity>> *)signature { return [NSSet setWithObject:self]; }

#pragma mark OWLNamedObject

- (OWLIRI *)IRI {
    return [[OWLIRI alloc] initWithCowlIRI:cowl_named_ind_get_iri(_cowlObject) retain:YES];
}

#pragma mark OWLEntity

- (OWLEntityType)entityType { return OWLEntityTypeNamedIndividual; }

- (BOOL)isOWLClass { return NO; }

- (BOOL)isOWLNamedIndividual { return YES; }

- (BOOL)isOWLObjectProperty { return NO; }

#pragma mark OWLIdentifiedEntity

- (OWLEntityID)identifier { return (OWLEntityID)_cowlObject; }

#pragma mark OWLIndividual

- (BOOL)anonymous { return NO; }

- (BOOL)named { return YES; }

- (id<OWLNamedIndividual>)asOWLNamedIndividual { return self; }

#pragma mark Lifecycle

- (instancetype)initWithCowlNamedInd:(CowlNamedInd *)cowlInd retain:(BOOL)retain {
    NSParameterAssert(cowlInd);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_named_ind_retain(cowlInd) : cowlInd;
    }
    return self;
}

- (instancetype)initWithIRI:(OWLIRI *)IRI {
    NSParameterAssert(IRI);
    return [self initWithCowlNamedInd:cowl_named_ind_get(IRI.cowlIRI) retain:NO];
}

- (void)dealloc { cowl_named_ind_release(_cowlObject); }

@end
