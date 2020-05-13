//
//  Created by Ivano Bilenchi on 27/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyCharacteristicAxiomImpl.h"
#import "OWLCowlUtils.h"
#import "cowl_obj_prop_char_axiom.h"

@implementation OWLObjectPropertyCharacteristicAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_obj_prop_char_axiom_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return (NSUInteger)cowl_obj_prop_char_axiom_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_obj_prop_char_axiom_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    [self.property enumerateSignatureWithHandler:handler];
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType {
    switch (cowl_obj_prop_char_axiom_get_type(_cowlObject)) {
        case COWL_CAT_ASYMM:
            return OWLAxiomTypeAsymmetricObjectProperty;

        case COWL_CAT_FUNC:
            return OWLAxiomTypeFunctionalObjectProperty;

        case COWL_CAT_REFL:
            return OWLAxiomTypeReflexiveObjectProperty;

        case COWL_CAT_SYMM:
            return OWLAxiomTypeSymmetricObjectProperty;

        case COWL_CAT_TRANS:
            return OWLAxiomTypeTransitiveObjectProperty;

        case COWL_CAT_IRREFL:
            return OWLAxiomTypeIrreflexiveObjectProperty;

        case COWL_CAT_INV_FUNC:
            return OWLAxiomTypeInverseFunctionalObjectProperty;

        default: {
            NSString *reason = @"Invalid axiom type.";
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:reason
                                         userInfo:nil];
        }
    }
}

#pragma mark OWLObjectPropertyCharacteristicAxiom

- (id<OWLObjectPropertyExpression>)property {
    return objPropExpFromCowl(cowl_obj_prop_char_axiom_get_prop(_cowlObject), YES);
}

#pragma mark Lifecycle

- (instancetype)initWithCowlAxiom:(CowlObjPropCharAxiom *)axiom retain:(BOOL)retain {
    NSParameterAssert(axiom);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_obj_prop_char_axiom_retain(axiom) : axiom;
    }
    return self;
}

- (instancetype)initWithType:(CowlCharAxiomType)type property:(id<OWLObjectPropertyExpression>)property {
    NSParameterAssert(property);
    CowlObjPropCharAxiom *axiom;
    axiom = cowl_obj_prop_char_axiom_get(type, ((OWLObjectImpl *)property)->_cowlObject, NULL);
    return [self initWithCowlAxiom:axiom retain:NO];
}

- (instancetype)initTransitiveObjectProperty:(id<OWLObjectPropertyExpression>)property {
    return [self initWithType:COWL_CAT_TRANS property:property];
}

- (void)dealloc { cowl_obj_prop_char_axiom_release(_cowlObject); }

@end
