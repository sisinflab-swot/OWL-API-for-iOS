//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLOntologyImpl.h"
#import "OWLCowlUtils.h"
#import "OWLIndividual.h"
#import "OWLObjCUtils.h"
#import "OWLOntologyID+Private.h"
#import "cowl_axiom.h"
#import "cowl_ontology.h"

#define forEachOWLAxiomType(types, type, code) do {                                                 \
    for (OWLAxiomType type = OWLAxiomTypeFirst; type <= OWLAxiomTypeLast; type <<= 1U) {            \
        if (has_option(types, type)) { code; }                                                      \
    }                                                                                               \
} while(0)

@implementation OWLOntologyImpl

#pragma mark Properties

@synthesize manager = _manager;

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_ontology_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return cowl_ontology_hash(_cowlObject); }

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    CowlIterator iter = cowl_iterator_init((__bridge void *)(handler), signatureIteratorImpl);
    cowl_ontology_iterate_primitives(_cowlObject, &iter, COWL_PF_ENTITY);
}

static bool classesIteratorImpl(void *ctx, void *cls) {
    void (^handler)(id<OWLClass>) = (__bridge void (^)(__strong id<OWLClass>))(ctx);
    handler(classFromCowl(cls, YES));
    return true;
}

- (void)enumerateClassesInSignatureWithHandler:(void (^)(id<OWLClass>))handler {
    CowlIterator iter = cowl_iterator_init((__bridge void *)(handler), classesIteratorImpl);
    cowl_ontology_iterate_classes(_cowlObject, &iter);
}

static bool namedIndIteratorImpl(void *ctx, void *ind) {
    void (^handler)(id<OWLNamedIndividual>) = (__bridge void (^)(__strong id<OWLNamedIndividual>))(ctx);
    handler(namedIndFromCowl(ind, YES));
    return true;
}

- (void)enumerateNamedIndividualsInSignatureWithHandler:(void (^)(id<OWLNamedIndividual>))handler {
    CowlIterator iter = cowl_iterator_init((__bridge void *)(handler), namedIndIteratorImpl);
    cowl_ontology_iterate_named_inds(_cowlObject, &iter);
}

static bool objPropIteratorImpl(void *ctx, void *prop) {
    void (^handler)(id<OWLObjectProperty>) = (__bridge void (^)(__strong id<OWLObjectProperty>))(ctx);
    handler(objPropFromCowl(prop, YES));
    return true;
}

- (void)enumerateObjectPropertiesInSignatureWithHandler:(void (^)(id<OWLObjectProperty>))handler {
    CowlIterator iter = cowl_iterator_init((__bridge void *)(handler), objPropIteratorImpl);
    cowl_ontology_iterate_obj_props(_cowlObject, &iter);
}

#pragma mark OWLOntology

static bool axiomIteratorImpl(void *ctx, void *axiom) {
    void (^handler)(id<OWLAxiom>) = (__bridge void (^)(__strong id<OWLAxiom>))(ctx);
    id<OWLAxiom> laxiom = axiomFromCowl(axiom, YES);
    if (laxiom) handler(laxiom);
    return true;
}

- (OWLOntologyID *)ontologyID {
    return [[OWLOntologyID alloc] initWithCowlID:cowl_ontology_get_id(_cowlObject)];
}

- (void)enumerateAxiomsWithHandler:(void (^)(id<OWLAxiom>))handler {
    CowlIterator iter = cowl_iterator_init((__bridge void *)(handler), axiomIteratorImpl);
    cowl_ontology_iterate_axioms(_cowlObject, &iter);
}

- (void)enumerateAxiomsOfTypes:(OWLAxiomType)types withHandler:(void (^)(id<OWLAxiom>))handler {
    CowlIterator iter = cowl_iterator_init((__bridge void *)(handler), axiomIteratorImpl);

    forEachOWLAxiomType(types, type, {
        cowl_ontology_iterate_axioms_of_type(_cowlObject, cowlAxiomTypeFrom(type), &iter);
    });
}

static bool axiomTypeIteratorImpl(void *ctx, void *axiom) {
    void **array = ctx;

    void (^handler)(id<OWLAxiom>) = (__bridge void (^)(__strong id<OWLAxiom>))(array[1]);
    OWLAxiomType types = *((OWLAxiomType *)array[0]);
    OWLAxiomType type = axiomTypeFromCowl(cowl_axiom_get_type(axiom));

    if (has_option(types, type)) {
        id<OWLAxiom> laxiom = axiomFromCowl(axiom, YES);
        if (laxiom) handler(laxiom);
    }

    return true;
}

- (void)enumerateAxiomsReferencingAnonymousIndividual:(id<OWLAnonymousIndividual>)individual
                                              ofTypes:(OWLAxiomType)types
                                          withHandler:(void(^)(id<OWLAxiom> axiom))handler {
    void *ctx[] = { &types, (__bridge void *)(handler) };
    CowlIterator iter = cowl_iterator_init(ctx, axiomTypeIteratorImpl);
    cowl_ontology_iterate_axioms_for_anon_ind(_cowlObject, cowlWrappedObject(individual), &iter);
}

- (void)enumerateAxiomsReferencingClass:(id<OWLClass>)cls
                                ofTypes:(OWLAxiomType)types
                            withHandler:(void (^)(id<OWLAxiom> axiom))handler {
    void *ctx[] = { &types, (__bridge void *)(handler) };
    CowlIterator iter = cowl_iterator_init(ctx, axiomTypeIteratorImpl);
    cowl_ontology_iterate_axioms_for_class(_cowlObject, cowlWrappedObject(cls), &iter);
}

- (void)enumerateAxiomsReferencingIndividual:(id<OWLIndividual>)individual
                                     ofTypes:(OWLAxiomType)types
                                 withHandler:(void (^)(id<OWLAxiom> axiom))handler {
    if (individual.anonymous) {
        [self enumerateAxiomsReferencingAnonymousIndividual:(id<OWLAnonymousIndividual>)individual
                                                    ofTypes:types
                                                withHandler:handler];
    } else {
        [self enumerateAxiomsReferencingNamedIndividual:(id<OWLNamedIndividual>)individual
                                                ofTypes:types
                                            withHandler:handler];
    }
}

- (void)enumerateAxiomsReferencingNamedIndividual:(id<OWLNamedIndividual>)individual
                                          ofTypes:(OWLAxiomType)types
                                      withHandler:(void (^)(id<OWLAxiom> axiom))handler {
    void *ctx[] = { &types, (__bridge void *)(handler) };
    CowlIterator iter = cowl_iterator_init(ctx, axiomTypeIteratorImpl);
    cowl_ontology_iterate_axioms_for_named_ind(_cowlObject, cowlWrappedObject(individual), &iter);
}

- (void)enumerateAxiomsReferencingObjectProperty:(id<OWLObjectProperty>)property
                                         ofTypes:(OWLAxiomType)types
                                     withHandler:(void (^)(id<OWLAxiom> axiom))handler {
    void *ctx[] = { &types, (__bridge void *)(handler) };
    CowlIterator iter = cowl_iterator_init(ctx, axiomTypeIteratorImpl);
    cowl_ontology_iterate_axioms_for_obj_prop(_cowlObject, cowlWrappedObject(property), &iter);
}

#pragma mark Lifecycle

- (instancetype)initWithCowlOntology:(CowlOntology *)ontology
                             manager:(id<OWLOntologyManager>)manager
                              retain:(BOOL)retain {
    NSParameterAssert(ontology);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_ontology_retain(ontology) : ontology;
        _manager = manager;
    }
    return self;
}

- (void)dealloc { cowl_ontology_release(_cowlObject); }

@end
