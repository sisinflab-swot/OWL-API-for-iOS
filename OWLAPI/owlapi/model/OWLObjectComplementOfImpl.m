//
//  Created by Ivano Bilenchi on 22/09/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObjectComplementOfImpl.h"
#import "OWLCowlUtils.h"
#import "cowl_obj_compl.h"

@implementation OWLObjectComplementOfImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_obj_compl_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return (NSUInteger)cowl_obj_compl_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_obj_compl_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    [self.operand enumerateSignatureWithHandler:handler];
}

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType { return OWLClassExpressionTypeObjectComplementOf; }

#pragma mark OWLObjectComplementOf

- (id<OWLClassExpression>)operand {
    return classExpressionFromCowl(cowl_obj_compl_get_operand(_cowlObject), YES);
}

#pragma mark Other public methods

- (instancetype)initWithCowlClsExp:(CowlObjCompl *)exp retain:(BOOL)retain {
    NSParameterAssert(exp);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_obj_compl_retain(exp) : exp;
    }
    return self;
}

- (instancetype)initWithOperand:(id<OWLClassExpression>)operand {
    NSParameterAssert(operand);
    CowlObjCompl *exp = cowl_obj_compl_get(((OWLObjectImpl *)operand)->_cowlObject);
    return [self initWithCowlClsExp:exp retain:NO];
}

- (void)dealloc { cowl_obj_compl_release(_cowlObject); }

@end
