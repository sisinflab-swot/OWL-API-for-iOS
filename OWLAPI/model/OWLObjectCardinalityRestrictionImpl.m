//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObjectCardinalityRestrictionImpl.h"
#import "OWLCowlUtils.h"

#import <cowl_obj_card.h>

@implementation OWLObjectCardinalityRestrictionImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_obj_card_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return (NSUInteger)cowl_obj_card_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_obj_card_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    CowlIterator iter = cowl_iterator_init((__bridge void *)(handler), signatureIteratorImpl);
    cowl_obj_card_iterate_primitives(_cowlObject, &iter, COWL_PF_ENTITY);
}

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType {
    switch (cowl_obj_card_get_type(_cowlObject)) {
        case COWL_CT_EXACT:
            return OWLClassExpressionTypeObjectExactCardinality;

        case COWL_CT_MAX:
            return OWLClassExpressionTypeObjectMaxCardinality;

        case COWL_CT_MIN:
            return OWLClassExpressionTypeObjectMinCardinality;

        default: {
            NSString *reason = @"Invalid cardinality restriction type.";
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:reason
                                         userInfo:nil];
        }
    }
}

#pragma mark OWLRestriction

- (BOOL)isObjectRestriction { return YES; }

- (BOOL)isDataRestriction { return NO; }

#pragma mark OWLCardinalityRestriction

- (NSUInteger)cardinality {
    return (NSUInteger)cowl_obj_card_get_cardinality(_cowlObject);
}

- (BOOL)qualified {
    id<OWLClassExpression> filler = self.filler;
    return filler.anonymous || !filler.isOWLThing;
}


#pragma mark OWLObjectCardinalityRestriction

- (id<OWLObjectPropertyExpression>)property {
    return objPropExpFromCowl(cowl_obj_card_get_prop(_cowlObject), YES);
}

- (id<OWLClassExpression>)filler {
    return classExpressionFromCowl(cowl_obj_card_get_filler(_cowlObject), YES);
}

#pragma mark Other public methods

- (instancetype)initWithCowlRestr:(CowlObjCard *)cowlRestr retain:(BOOL)retain {
    NSParameterAssert(cowlRestr);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_obj_card_retain(cowlRestr) : cowlRestr;
    }
    return self;
}

- (instancetype)initWithType:(CowlCardType)type
                    property:(id<OWLObjectPropertyExpression>)property
                      filler:(id<OWLClassExpression>)filler
                 cardinality:(NSUInteger)cardinality {
    NSParameterAssert(property);
    CowlObjCard *crestr = cowl_obj_card_get(type, ((OWLObjectImpl *)property).cowlObject,
                                            ((OWLObjectImpl *)filler).cowlObject,
                                            (cowl_uint)cardinality);
    return [self initWithCowlRestr:crestr retain:NO];
}

- (instancetype)initExactCardinalityWithProperty:(id<OWLObjectPropertyExpression>)property
                                          filler:(id<OWLClassExpression>)filler
                                     cardinality:(NSUInteger)cardinality {
    return [self initWithType:COWL_CT_EXACT property:property filler:filler cardinality:cardinality];
}

- (instancetype)initMaxCardinalityWithProperty:(id<OWLObjectPropertyExpression>)property
                                        filler:(id<OWLClassExpression>)filler
                                   cardinality:(NSUInteger)cardinality {
    return [self initWithType:COWL_CT_MAX property:property filler:filler cardinality:cardinality];

}

- (instancetype)initMinCardinalityWithProperty:(id<OWLObjectPropertyExpression>)property
                                        filler:(id<OWLClassExpression>)filler
                                   cardinality:(NSUInteger)cardinality {
    return [self initWithType:COWL_CT_MIN property:property filler:filler cardinality:cardinality];
}

- (void)dealloc { cowl_obj_card_release(_cowlObject); }

@end
