//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLQuantifiedObjectRestrictionImpl.h"
#import "OWLCowlUtils.h"

#import <cowl_obj_quant.h>

@implementation OWLQuantifiedObjectRestrictionImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_obj_quant_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return cowl_obj_quant_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_obj_quant_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    CowlIterator iter = cowl_iterator_init((__bridge void *)(handler), signatureIteratorImpl);
    cowl_obj_quant_iterate_primitives(_cowlObject, &iter, COWL_PF_ENTITY);
}


#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType {
    if (cowl_obj_quant_get_type(_cowlObject) == COWL_QT_ALL) {
        return OWLClassExpressionTypeObjectAllValuesFrom;
    } else {
        return OWLClassExpressionTypeObjectSomeValuesFrom;
    }
}

#pragma mark OWLRestriction

- (BOOL)isObjectRestriction { return YES; }

- (BOOL)isDataRestriction { return NO; }

#pragma mark OWLQuantifiedObjectRestriction

- (id<OWLObjectPropertyExpression>)property {
    return objPropExpFromCowl(cowl_obj_quant_get_prop(_cowlObject), YES);
}

- (id<OWLClassExpression>)filler {
    return classExpressionFromCowl(cowl_obj_quant_get_filler(_cowlObject), YES);
}

#pragma mark Other public methods

- (instancetype)initWithCowlClsExp:(CowlObjQuant *)exp retain:(BOOL)retain {
    NSParameterAssert(exp);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_obj_quant_retain(exp) : exp;
    }
    return self;
}

- (instancetype)initWithType:(CowlQuantType)type
                    property:(id<OWLObjectPropertyExpression>)property
                      filler:(id<OWLClassExpression>)filler {
    NSParameterAssert(property);
    CowlObjQuant *exp = cowl_obj_quant_get(type, ((OWLObjectImpl *)property)->_cowlObject,
                                           ((OWLObjectImpl *)filler)->_cowlObject);
    return [self initWithCowlClsExp:exp retain:NO];
}

- (instancetype)initExsistentialWithProperty:(id<OWLObjectPropertyExpression>)property
                                      filler:(id<OWLClassExpression>)filler {
    return [self initWithType:COWL_QT_SOME property:property filler:filler];
}

- (instancetype)initUniversalWithProperty:(id<OWLObjectPropertyExpression>)property
                                   filler:(id<OWLClassExpression>)filler {
    return [self initWithType:COWL_QT_ALL property:property filler:filler];
}

- (void)dealloc { cowl_obj_quant_release(_cowlObject); }

@end
