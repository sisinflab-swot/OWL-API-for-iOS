//
//  Created by Ivano Bilenchi on 10/05/2020.
//  Copyright © 2020 SisInf Lab. All rights reserved.
//

#import "OWLCowlUtils.h"
#import "OWLAnonymousIndividualImpl.h"
#import "OWLClassAssertionAxiomImpl.h"
#import "OWLClassImpl.h"
#import "OWLDeclarationAxiomImpl.h"
#import "OWLError.h"
#import "OWLNamedIndividualImpl.h"
#import "OWLNAryBooleanClassExpressionImpl.h"
#import "OWLNAryClassAxiomImpl.h"
#import "OWLObjectCardinalityRestrictionImpl.h"
#import "OWLObjectComplementOfImpl.h"
#import "OWLObjectImpl.h"
#import "OWLObjectPropertyAssertionAxiomImpl.h"
#import "OWLObjectPropertyCharacteristicAxiomImpl.h"
#import "OWLObjectPropertyDomainAxiomImpl.h"
#import "OWLObjectPropertyRangeAxiomImpl.h"
#import "OWLObjectPropertyImpl.h"
#import "OWLQuantifiedObjectRestrictionImpl.h"
#import "OWLSubClassOfAxiomImpl.h"

#import "cowl_axiom.h"
#import "cowl_cls_exp.h"
#import "cowl_cls_exp_set.h"
#import "cowl_individual.h"
#import "cowl_obj_prop_exp.h"
#import "cowl_string.h"

CowlClsExpSet* cowlClsExpSetFrom(NSSet<id<OWLClassExpression>> *set) {
    UHash(CowlClsExpSet) *cowlSet = uhset_alloc(CowlClsExpSet);
    uhash_resize(CowlClsExpSet, cowlSet, (uhash_uint_t)set.count);

    for (OWLObjectImpl *exp in set) {
        uhset_insert(CowlClsExpSet, cowlSet, cowl_cls_exp_retain(exp.cowlObject));
    }

    return cowlSet;
}

CowlEntity* cowlEntityFrom(id<OWLEntity> entity) {
    return cowlWrappedObject(entity);
}

void* cowlWrappedObject(id object) {
    return ((OWLObjectImpl *)object).cowlObject;
}

extern CowlAxiomType cowlAxiomTypeFrom(OWLAxiomType type) {
    switch (type) {
        case OWLAxiomTypeDeclaration: return COWL_AT_DECL;
        case OWLAxiomTypeDatatypeDefinition: return COWL_AT_DATATYPE_DEF;
        case OWLAxiomTypeEquivalentClasses: return COWL_AT_EQUIV_CLASSES;
        case OWLAxiomTypeSubClassOf: return COWL_AT_SUB_CLASS;
        case OWLAxiomTypeDisjointClasses: return COWL_AT_DISJ_CLASSES;
        case OWLAxiomTypeDisjointUnion: return COWL_AT_DISJ_UNION;
        case OWLAxiomTypeClassAssertion: return COWL_AT_CLASS_ASSERT;
        case OWLAxiomTypeSameIndividual: return COWL_AT_SAME_IND;
        case OWLAxiomTypeDifferentIndividuals: return COWL_AT_DIFF_IND;
        case OWLAxiomTypeObjectPropertyAssertion: return COWL_AT_OBJ_PROP_ASSERT;
        case OWLAxiomTypeNegativeObjectPropertyAssertion: return COWL_AT_NEG_OBJ_PROP_ASSERT;
        case OWLAxiomTypeDataPropertyAssertion: return COWL_AT_DATA_PROP_ASSERT;
        case OWLAxiomTypeNegativeDataPropertyAssertion: return COWL_AT_NEG_DATA_PROP_ASSERT;
        case OWLAxiomTypeEquivalentObjectProperties: return COWL_AT_EQUIV_OBJ_PROP;
        case OWLAxiomTypeSubObjectPropertyOf: return COWL_AT_SUB_OBJ_PROP;
        case OWLAxiomTypeInverseObjectProperties: return COWL_AT_INV_OBJ_PROP;
        case OWLAxiomTypeFunctionalObjectProperty: return COWL_AT_FUNC_OBJ_PROP;
        case OWLAxiomTypeInverseFunctionalObjectProperty: return COWL_AT_INV_FUNC_OBJ_PROP;
        case OWLAxiomTypeSymmetricObjectProperty: return COWL_AT_SYMM_OBJ_PROP;
        case OWLAxiomTypeAsymmetricObjectProperty: return COWL_AT_ASYMM_OBJ_PROP;
        case OWLAxiomTypeTransitiveObjectProperty: return COWL_AT_TRANS_OBJ_PROP;
        case OWLAxiomTypeReflexiveObjectProperty: return COWL_AT_REFL_OBJ_PROP;
        case OWLAxiomTypeIrreflexiveObjectProperty: return COWL_AT_IRREFL_OBJ_PROP;
        case OWLAxiomTypeObjectPropertyDomain: return COWL_AT_OBJ_PROP_DOMAIN;
        case OWLAxiomTypeObjectPropertyRange: return COWL_AT_OBJ_PROP_RANGE;
        case OWLAxiomTypeDisjointObjectProperties: return COWL_AT_DISJ_OBJ_PROP;
        case OWLAxiomTypeSubPropertyChainOf: return COWL_AT_SUB_OBJ_PROP_CHAIN;
        case OWLAxiomTypeEquivalentDataProperties: return COWL_AT_EQUIV_DATA_PROP;
        case OWLAxiomTypeSubDataPropertyOf: return COWL_AT_SUB_DATA_PROP;
        case OWLAxiomTypeFunctionalDataProperty: return COWL_AT_FUNC_DATA_PROP;
        case OWLAxiomTypeDataPropertyDomain: return COWL_AT_DATA_PROP_DOMAIN;
        case OWLAxiomTypeDataPropertyRange: return COWL_AT_DATA_PROP_RANGE;
        case OWLAxiomTypeDisjointDataProperties: return COWL_AT_DISJ_DATA_PROP;
        case OWLAxiomTypeHasKey: return COWL_AT_HAS_KEY;
        case OWLAxiomTypeAnnotationAssertion: return COWL_AT_ANNOT_ASSERT;
        case OWLAxiomTypeSubAnnotationPropertyOf: return COWL_AT_SUB_ANNOT_PROP;
        case OWLAxiomTypeAnnotationPropertyRange: return COWL_AT_ANNOT_PROP_RANGE;
        case OWLAxiomTypeAnnotationPropertyDomain: return COWL_AT_ANNOT_PROP_DOMAIN;
        default: {
            NSString *reason = @"Invalid axiom type.";
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:reason
                                         userInfo:nil];
        }
    }
}

OWLAxiomType axiomTypeFromCowl(CowlAxiomType type) {
    switch (type) {
        case COWL_AT_DECL: return OWLAxiomTypeDeclaration;
        case COWL_AT_DATATYPE_DEF: return OWLAxiomTypeDatatypeDefinition;
        case COWL_AT_EQUIV_CLASSES: return OWLAxiomTypeEquivalentClasses;
        case COWL_AT_SUB_CLASS: return OWLAxiomTypeSubClassOf;
        case COWL_AT_DISJ_CLASSES: return OWLAxiomTypeDisjointClasses;
        case COWL_AT_DISJ_UNION: return OWLAxiomTypeDisjointUnion;
        case COWL_AT_CLASS_ASSERT: return OWLAxiomTypeClassAssertion;
        case COWL_AT_SAME_IND: return OWLAxiomTypeSameIndividual;
        case COWL_AT_DIFF_IND: return OWLAxiomTypeDifferentIndividuals;
        case COWL_AT_OBJ_PROP_ASSERT: return OWLAxiomTypeObjectPropertyAssertion;
        case COWL_AT_NEG_OBJ_PROP_ASSERT: return OWLAxiomTypeNegativeObjectPropertyAssertion;
        case COWL_AT_DATA_PROP_ASSERT: return OWLAxiomTypeDataPropertyAssertion;
        case COWL_AT_NEG_DATA_PROP_ASSERT: return OWLAxiomTypeNegativeDataPropertyAssertion;
        case COWL_AT_EQUIV_OBJ_PROP: return OWLAxiomTypeEquivalentObjectProperties;
        case COWL_AT_SUB_OBJ_PROP: return OWLAxiomTypeSubObjectPropertyOf;
        case COWL_AT_INV_OBJ_PROP: return OWLAxiomTypeInverseObjectProperties;
        case COWL_AT_FUNC_OBJ_PROP: return OWLAxiomTypeFunctionalObjectProperty;
        case COWL_AT_INV_FUNC_OBJ_PROP: return OWLAxiomTypeInverseFunctionalObjectProperty;
        case COWL_AT_SYMM_OBJ_PROP: return OWLAxiomTypeSymmetricObjectProperty;
        case COWL_AT_ASYMM_OBJ_PROP: return OWLAxiomTypeAsymmetricObjectProperty;
        case COWL_AT_TRANS_OBJ_PROP: return OWLAxiomTypeTransitiveObjectProperty;
        case COWL_AT_REFL_OBJ_PROP: return OWLAxiomTypeReflexiveObjectProperty;
        case COWL_AT_IRREFL_OBJ_PROP: return OWLAxiomTypeIrreflexiveObjectProperty;
        case COWL_AT_OBJ_PROP_DOMAIN: return OWLAxiomTypeObjectPropertyDomain;
        case COWL_AT_OBJ_PROP_RANGE: return OWLAxiomTypeObjectPropertyRange;
        case COWL_AT_DISJ_OBJ_PROP: return OWLAxiomTypeDisjointObjectProperties;
        case COWL_AT_SUB_OBJ_PROP_CHAIN: return OWLAxiomTypeSubPropertyChainOf;
        case COWL_AT_EQUIV_DATA_PROP: return OWLAxiomTypeEquivalentDataProperties;
        case COWL_AT_SUB_DATA_PROP: return OWLAxiomTypeSubDataPropertyOf;
        case COWL_AT_FUNC_DATA_PROP: return OWLAxiomTypeFunctionalDataProperty;
        case COWL_AT_DATA_PROP_DOMAIN: return OWLAxiomTypeDataPropertyDomain;
        case COWL_AT_DATA_PROP_RANGE: return OWLAxiomTypeDataPropertyRange;
        case COWL_AT_DISJ_DATA_PROP: return OWLAxiomTypeDisjointDataProperties;
        case COWL_AT_HAS_KEY: return OWLAxiomTypeHasKey;
        case COWL_AT_ANNOT_ASSERT: return OWLAxiomTypeAnnotationAssertion;
        case COWL_AT_SUB_ANNOT_PROP: return OWLAxiomTypeSubAnnotationPropertyOf;
        case COWL_AT_ANNOT_PROP_RANGE: return OWLAxiomTypeAnnotationPropertyRange;
        case COWL_AT_ANNOT_PROP_DOMAIN: return OWLAxiomTypeAnnotationPropertyDomain;
        default: {
            NSString *reason = @"Invalid axiom type.";
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:reason
                                         userInfo:nil];
        }
    }
}

id<OWLAxiom> axiomFromCowl(CowlAxiom *axiom, BOOL retain) {
    switch (cowl_axiom_get_type(axiom)) {
        case COWL_AT_DECL: return [[OWLDeclarationAxiomImpl alloc] initWithCowlAxiom:(CowlDeclAxiom *)axiom retain:retain];
        case COWL_AT_EQUIV_CLASSES:
        case COWL_AT_DISJ_CLASSES: return [[OWLNAryClassAxiomImpl alloc] initWithCowlAxiom:(CowlNAryClsAxiom *)axiom retain:retain];
        case COWL_AT_SUB_CLASS: return [[OWLSubClassOfAxiomImpl alloc] initWithCowlAxiom:(CowlSubClsAxiom *)axiom retain:retain];
        case COWL_AT_CLASS_ASSERT: return [[OWLClassAssertionAxiomImpl alloc] initWithCowlAxiom:(CowlClsAssertAxiom *)axiom retain:retain];
        case COWL_AT_OBJ_PROP_ASSERT: return [[OWLObjectPropertyAssertionAxiomImpl alloc] initWithCowlAxiom:(CowlObjPropAssertAxiom *)axiom retain:retain];
        case COWL_AT_TRANS_OBJ_PROP: return [[OWLObjectPropertyCharacteristicAxiomImpl alloc] initWithCowlAxiom:(CowlObjPropCharAxiom *)axiom retain:retain];
        case COWL_AT_OBJ_PROP_DOMAIN: return [[OWLObjectPropertyDomainAxiomImpl alloc] initWithCowlAxiom:(CowlObjPropDomainAxiom *)axiom retain:retain];
        case COWL_AT_OBJ_PROP_RANGE: return [[OWLObjectPropertyRangeAxiomImpl alloc] initWIthCowlAxiom:(CowlObjPropRangeAxiom *)axiom retain:retain];
        default: return nil;
    }
}

id<OWLClass> classFromCowl(CowlClass *cls, BOOL retain) {
    return [[OWLClassImpl alloc] initWithCowlClass:cls retain:retain];
}

id<OWLClassExpression> classExpressionFromCowl(CowlClsExp *exp, BOOL retain) {
    switch (cowl_cls_exp_get_type(exp)) {
        case COWL_CET_CLASS: return [[OWLClassImpl alloc] initWithCowlClass:(CowlClass *)exp retain:retain];
        case COWL_CET_OBJ_ALL:
        case COWL_CET_OBJ_SOME: return [[OWLQuantifiedObjectRestrictionImpl alloc] initWithCowlClsExp:(CowlObjQuant *)exp retain:retain];
        case COWL_CET_OBJ_COMPL: return [[OWLObjectComplementOfImpl alloc] initWithCowlClsExp:(CowlObjCompl *)exp retain:retain];
        case COWL_CET_OBJ_INTERSECT: return [[OWLNAryBooleanClassExpressionImpl alloc] initWithCowlClsExp:(CowlNAryBool *)exp retain:retain];
        case COWL_CET_OBJ_EXACT_CARD:
        case COWL_CET_OBJ_MAX_CARD:
        case COWL_CET_OBJ_MIN_CARD: return [[OWLObjectCardinalityRestrictionImpl alloc] initWithCowlRestr:(CowlObjCard *)exp retain:retain];
        default: return nil;
    }
}

NSSet<id<OWLClassExpression>>* classExpressionSetFromCowl(CowlClsExpSet *set, BOOL retain) {
    NSMutableSet *lset = [[NSMutableSet alloc] initWithCapacity:(NSUInteger)uhash_count(set)];

    uhash_foreach_key(CowlClsExpSet, set, exp, {
        id<OWLClassExpression> lexp = classExpressionFromCowl(exp, retain);
        if (lexp) [lset addObject:lexp];
    });

    return lset;
}

id<OWLEntity> entityFromCowl(CowlEntity *entity, BOOL retain) {
    switch (cowl_entity_get_type(entity)) {
        case COWL_ET_CLASS:
            return [[OWLClassImpl alloc] initWithCowlClass:(CowlClass *)entity
                                                    retain:retain];

        case COWL_ET_NAMED_IND:
            return [[OWLNamedIndividualImpl alloc] initWithCowlNamedInd:(CowlNamedInd *)entity
                                                                 retain:retain];

        case COWL_ET_OBJ_PROP:
            return [[OWLObjectPropertyImpl alloc] initWithCowlProperty:(CowlObjProp *)entity
                                                                retain:retain];

        default:
            return nil;
    }
}

NSError* errorFromCowl(CowlError error) {
    return [NSError OWLErrorWithCowlError:error];
}

id<OWLIndividual> individualFromCowl(CowlIndividual *ind, BOOL retain) {
    if (cowl_individual_is_named(ind)) {
        return [[OWLNamedIndividualImpl alloc] initWithCowlNamedInd:(CowlNamedInd *)ind
                                                             retain:retain];
    } else {
        return [[OWLAnonymousIndividualImpl alloc] initWithCowlIndividual:(CowlAnonInd *)ind
                                                                   retain:retain];
    }
}

id<OWLNamedIndividual> namedIndFromCowl(CowlNamedInd *ind, BOOL retain) {
    return [[OWLNamedIndividualImpl alloc] initWithCowlNamedInd:ind retain:retain];
}

id<OWLObjectProperty> objPropFromCowl(CowlObjProp *prop, BOOL retain) {
    return [[OWLObjectPropertyImpl alloc] initWithCowlProperty:prop retain:retain];
}

id<OWLObjectPropertyExpression> objPropExpFromCowl(CowlObjPropExp *exp, BOOL retain) {
    if (cowl_obj_prop_exp_is_inverse(exp)) {
        return nil;
    } else {
        return [[OWLObjectPropertyImpl alloc] initWithCowlProperty:(CowlObjProp *)exp retain:retain];
    }
}

NSString* stringFromCowl(CowlString *string, BOOL release) {
    NSString *str = [[NSString alloc] initWithBytes:cowl_string_get_cstring(string)
                                             length:(NSUInteger)cowl_string_get_length(string)
                                           encoding:NSUTF8StringEncoding];
    if (release) cowl_string_release(string);
    return str;
}
