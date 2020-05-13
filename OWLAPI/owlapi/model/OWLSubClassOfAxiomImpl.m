//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLSubClassOfAxiomImpl.h"
#import "OWLCowlUtils.h"
#import "cowl_sub_cls_axiom.h"

@implementation OWLSubClassOfAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_sub_cls_axiom_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return (NSUInteger)cowl_sub_cls_axiom_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_sub_cls_axiom_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    CowlEntityIterator iter = cowl_iterator_init((__bridge void *)(handler), signatureIteratorImpl);
    cowl_sub_cls_axiom_iterate_signature(_cowlObject, &iter);
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeSubClassOf; }

#pragma mark OWLSubClassOfAxiom

- (id<OWLClassExpression>)superClass {
    return classExpressionFromCowl(cowl_sub_cls_axiom_get_super(_cowlObject), YES);
}

- (id<OWLClassExpression>)subClass {
    return classExpressionFromCowl(cowl_sub_cls_axiom_get_sub(_cowlObject), YES);
}

#pragma mark Lifecycle

- (instancetype)initWithCowlAxiom:(CowlSubClsAxiom *)axiom retain:(BOOL)retain {
    NSParameterAssert(axiom);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_sub_cls_axiom_retain(axiom) : axiom;
    }
    return self;
}

- (instancetype)initWithSuperClass:(id<OWLClassExpression>)superClass
                          subClass:(id<OWLClassExpression>)subClass {
    NSParameterAssert(superClass && subClass);
    CowlSubClsAxiom *axiom;
    axiom = cowl_sub_cls_axiom_get(((OWLObjectImpl *)subClass)->_cowlObject,
                                   ((OWLObjectImpl *)superClass)->_cowlObject, NULL);
    return [self initWithCowlAxiom:axiom retain:NO];
}

- (void)dealloc { cowl_sub_cls_axiom_release(_cowlObject); }

@end
