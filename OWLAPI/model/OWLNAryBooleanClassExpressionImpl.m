//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLNAryBooleanClassExpressionImpl.h"
#import "OWLCowlUtils.h"
#import "cowl_nary_bool.h"

@implementation OWLNAryBooleanClassExpressionImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_nary_bool_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return cowl_nary_bool_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_nary_bool_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    CowlIterator iter = cowl_iterator_init((__bridge void *)(handler), signatureIteratorImpl);
    cowl_nary_bool_iterate_primitives(_cowlObject, &iter, COWL_PF_ENTITY);
}

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType {
    if (cowl_nary_bool_get_type(_cowlObject) == COWL_NT_INTERSECT) {
        return OWLClassExpressionTypeObjectIntersectionOf;
    } else {
        return OWLClassExpressionTypeObjectUnionOf;
    }
}

- (NSSet<id<OWLClassExpression>> *)asConjunctSet {
    if (self.classExpressionType != OWLClassExpressionTypeObjectIntersectionOf) {
        return [NSSet setWithObject:self];
    }

    NSMutableSet *set = [[NSMutableSet alloc] init];

    for (id<OWLClassExpression> operand in self.operands) {
        [set unionSet:[operand asConjunctSet]];
    }

    return set;
}

#pragma mark OWLNAryBooleanClassExpression

- (NSSet<id<OWLClassExpression>> *)operands {
    return classExpressionSetFromCowl(cowl_nary_bool_get_operands(_cowlObject), YES);
}

#pragma mark Other public methods

- (instancetype)initWithCowlClsExp:(CowlNAryBool *)exp retain:(BOOL)retain {
    NSParameterAssert(exp);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_nary_bool_retain(exp) : exp;
    }
    return self;
}

- (instancetype)initWithType:(CowlNAryType)type operands:(NSSet<id<OWLClassExpression>>*)operands {
    NSParameterAssert(operands.count);
    CowlNAryBool *exp = cowl_nary_bool_get(type, cowlClsExpSetFrom(operands));
    return [self initWithCowlClsExp:exp retain:NO];
}

- (instancetype)initIntersection:(NSSet<id<OWLClassExpression>> *)operands {
    return [self initWithType:COWL_NT_INTERSECT operands:operands];
}

- (instancetype)initUnion:(NSSet<id<OWLClassExpression>> *)operands {
    return [self initWithType:COWL_NT_UNION operands:operands];
}

- (void)dealloc { cowl_nary_bool_release(_cowlObject); }

@end
