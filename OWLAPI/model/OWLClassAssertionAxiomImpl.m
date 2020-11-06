//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLClassAssertionAxiomImpl.h"
#import "OWLCowlUtils.h"
#import "cowl_cls_assert_axiom.h"

@implementation OWLClassAssertionAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_cls_assert_axiom_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return cowl_cls_assert_axiom_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_cls_assert_axiom_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    CowlIterator iter = cowl_iterator_init((__bridge void *)(handler), signatureIteratorImpl);
    cowl_cls_assert_axiom_iterate_primitives(_cowlObject, &iter, COWL_PF_ENTITY);
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeClassAssertion; }

#pragma mark OWLClassAssertionAxiom

- (id<OWLIndividual>)individual {
    return individualFromCowl(cowl_cls_assert_axiom_get_ind(_cowlObject), YES);
}

- (id<OWLClassExpression>)classExpression {
    return classExpressionFromCowl(cowl_cls_assert_axiom_get_cls_exp(_cowlObject), YES);
}

#pragma mark Other public methods

- (instancetype)initWithCowlAxiom:(CowlClsAssertAxiom *)axiom retain:(BOOL)retain {
    NSParameterAssert(axiom);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_cls_assert_axiom_retain(axiom) : axiom;
    }
    return self;
}

- (instancetype)initWithIndividual:(id<OWLIndividual>)individual
                   classExpression:(id<OWLClassExpression>)classExpression
{
    NSParameterAssert(individual && classExpression);
    CowlClsAssertAxiom *axiom = cowl_cls_assert_axiom_get(((OWLObjectImpl *)individual)->_cowlObject,
                                                          ((OWLObjectImpl *)classExpression)->_cowlObject,
                                                          NULL);
    return [self initWithCowlAxiom:axiom retain:NO];
}

- (void)dealloc { cowl_cls_assert_axiom_release(_cowlObject); }

@end
