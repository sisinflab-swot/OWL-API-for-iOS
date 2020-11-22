//
//  Created by Ivano Bilenchi on 22/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyAssertionAxiomImpl.h"
#import "OWLCowlUtils.h"

#import <cowl_obj_prop_assert_axiom.h>

@implementation OWLObjectPropertyAssertionAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_obj_prop_assert_axiom_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return (NSUInteger)cowl_obj_prop_assert_axiom_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_obj_prop_assert_axiom_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    CowlIterator iter = cowl_iterator_init((__bridge void *)(handler), signatureIteratorImpl);
    cowl_obj_prop_assert_axiom_iterate_primitives(_cowlObject, &iter, COWL_PF_ENTITY);
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeObjectPropertyAssertion; }

#pragma mark OWLObjectPropertyAssertionAxiom

- (id<OWLIndividual>)subject {
    return individualFromCowl(cowl_obj_prop_assert_axiom_get_subject(_cowlObject), YES);
}

- (id<OWLObjectPropertyExpression>)property {
    return objPropExpFromCowl(cowl_obj_prop_assert_axiom_get_prop(_cowlObject), YES);
}

- (id<OWLIndividual>)object {
    return individualFromCowl(cowl_obj_prop_assert_axiom_get_object(_cowlObject), YES);
}

#pragma mark Lifecycle

- (instancetype)initWithCowlAxiom:(CowlObjPropAssertAxiom *)axiom retain:(BOOL)retain {
    NSParameterAssert(axiom);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_obj_prop_assert_axiom_retain(axiom) : axiom;
    }
    return self;
}

- (instancetype)initWithSubject:(id<OWLIndividual>)subject
                       property:(id<OWLObjectPropertyExpression>)property
                         object:(id<OWLIndividual>)object {
    NSParameterAssert(subject && property && object);
    CowlObjPropAssertAxiom *axiom;
    axiom = cowl_obj_prop_assert_axiom_get(((OWLObjectImpl *)subject)->_cowlObject,
                                           ((OWLObjectImpl *)property)->_cowlObject,
                                           ((OWLObjectImpl *)object)->_cowlObject,
                                           NULL);
    return [self initWithCowlAxiom:axiom retain:NO];
}

- (void)dealloc { cowl_obj_prop_assert_axiom_release(_cowlObject); }

@end
