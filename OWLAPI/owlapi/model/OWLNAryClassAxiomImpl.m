//
//  Created by Ivano Bilenchi on 09/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLNAryClassAxiomImpl.h"
#import "OWLClassExpression.h"
#import "OWLCowlUtils.h"
#import "cowl_nary_cls_axiom.h"

@implementation OWLNAryClassAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_nary_cls_axiom_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return (NSUInteger)cowl_nary_cls_axiom_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_nary_cls_axiom_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    CowlEntityIterator iter = cowl_iterator_init((__bridge void *)(handler), signatureIteratorImpl);
    cowl_nary_cls_axiom_iterate_signature(_cowlObject, &iter);
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType {
    if (cowl_nary_cls_axiom_get_type(_cowlObject) == COWL_NAT_DISJ) {
        return OWLAxiomTypeDisjointClasses;
    } else {
        return OWLAxiomTypeEquivalentClasses;
    }
}

#pragma mark OWLNAryClassAxiom

- (NSSet<id<OWLClassExpression>> *)classExpressions {
    return classExpressionSetFromCowl(cowl_nary_cls_axiom_get_classes(_cowlObject), YES);
}

#pragma mark Other public methods

- (instancetype)initWithCowlAxiom:(CowlNAryClsAxiom *)axiom retain:(BOOL)retain {
    NSParameterAssert(axiom);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_nary_cls_axiom_retain(axiom) : axiom;
    }
    return self;
}

- (instancetype)initWithType:(CowlNAryAxiomType)type classes:(NSSet<id<OWLClassExpression>>*)classes {
    NSParameterAssert(classes.count);
    CowlNAryClsAxiom *axiom = cowl_nary_cls_axiom_get(type, cowlClsExpSetFrom(classes), NULL);
    return [self initWithCowlAxiom:axiom retain:NO];
}

- (instancetype)initWithDisjointClasses:(NSSet<id<OWLClassExpression>> *)classes {
    return [self initWithType:COWL_NAT_DISJ classes:classes];
}

- (instancetype)initWithEquivalentClasses:(NSSet<id<OWLClassExpression>> *)classes {
    return [self initWithType:COWL_NAT_EQUIV classes:classes];
}

- (void)dealloc { cowl_nary_cls_axiom_release(_cowlObject); }

@end
