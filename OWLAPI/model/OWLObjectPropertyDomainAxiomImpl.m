//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyDomainAxiomImpl.h"
#import "OWLCowlUtils.h"
#import "cowl_obj_prop_domain_axiom.h"

@implementation OWLObjectPropertyDomainAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_obj_prop_domain_axiom_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return (NSUInteger)cowl_obj_prop_domain_axiom_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_obj_prop_domain_axiom_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    CowlEntityIterator iter = cowl_iterator_init((__bridge void *)(handler), signatureIteratorImpl);
    cowl_obj_prop_domain_axiom_iterate_signature(_cowlObject, &iter);
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeObjectPropertyDomain; }

#pragma mark OWLPropertyDomainAxiom

- (id<OWLObjectPropertyExpression>)property {
    return objPropExpFromCowl(cowl_obj_prop_domain_axiom_get_prop(_cowlObject), YES);
}

- (id<OWLClassExpression>)domain {
    return classExpressionFromCowl(cowl_obj_prop_domain_axiom_get_domain(_cowlObject), YES);
}

#pragma mark Other public methods

- (instancetype)initWithCowlAxiom:(CowlObjPropDomainAxiom *)axiom retain:(BOOL)retain {
    NSParameterAssert(axiom);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_obj_prop_domain_axiom_retain(axiom) : axiom;
    }
    return self;
}

- (instancetype)initWithProperty:(id<OWLObjectPropertyExpression>)property
                          domain:(id<OWLClassExpression>)domain {
    NSParameterAssert(property && domain);
    CowlObjPropDomainAxiom *axiom;
    axiom = cowl_obj_prop_domain_axiom_get(((OWLObjectImpl *)property)->_cowlObject,
                                           ((OWLObjectImpl *)domain)->_cowlObject,
                                           NULL);
    return [self initWithCowlAxiom:axiom retain:NO];
}

- (void)dealloc { cowl_obj_prop_domain_axiom_release(_cowlObject); }

@end
