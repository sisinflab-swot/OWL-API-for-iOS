//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntologyImpl.h"
#import "OWLOntologyID.h"
#import "OWLOntologyInternals.h"

@interface OWLOntologyImpl ()

@property (nonatomic, strong) OWLOntologyInternals *internals;

@end


@implementation OWLOntologyImpl

#pragma mark Properties

@synthesize internals = _internals;
@synthesize manager = _manager;
@synthesize ontologyID = _ontologyID;

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        id objID = ((OWLOntologyImpl *)object)->_ontologyID;
        equal = (objID == _ontologyID || [objID isEqual:_ontologyID]);
    }
    
    return equal;
}

- (NSUInteger)computeHash { return [_ontologyID hash]; }

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [[NSMutableSet alloc] initWithSet:self.classesInSignature];
    [signature unionSet:self.objectPropertiesInSignature];
    [signature unionSet:self.namedIndividualsInSignature];
    return signature;
}

- (NSSet<id<OWLClass>> *)classesInSignature { return [_internals allClasses]; }

- (NSSet<id<OWLNamedIndividual>> *)namedIndividualsInSignature { return [_internals allNamedIndividuals]; }

- (NSSet<id<OWLObjectProperty>> *)objectPropertiesInSignature { return [_internals allObjectProperties]; }

#pragma mark OWLOntology

- (NSSet<id<OWLAxiom>> *)allAxioms
{
    return [_internals allAxioms];
}

- (NSSet<id<OWLAxiom>> *)axiomsForType:(OWLAxiomType)type
{
    return [_internals axiomsForType:type];
}

- (NSSet<id<OWLClassAssertionAxiom>> *)classAssertionAxiomsForIndividual:(id<OWLIndividual>)individual
{
    return [_internals classAssertionAxiomsForIndividual:individual];
}

- (NSSet<id<OWLDisjointClassesAxiom>> *)disjointClassesAxiomsForClass:(id<OWLClass>)cls
{
    return [_internals disjointClassesAxiomsForClass:cls];
}

- (NSSet<id<OWLEquivalentClassesAxiom>> *)equivalentClassesAxiomsForClass:(id<OWLClass>)cls
{
    return [_internals equivalentClassesAxiomsForClass:cls];
}

- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSubClass:(id<OWLClass>)cls
{
    return [_internals subClassAxiomsForSubClass:cls];
}

- (NSSet<id<OWLSubClassOfAxiom>> *)subClassAxiomsForSuperClass:(id<OWLClass>)cls
{
    return [_internals subClassAxiomsForSuperClass:cls];
}

- (void)enumerateAxiomsReferencingAnonymousIndividual:(id<OWLAnonymousIndividual>)individual ofTypes:(OWLAxiomType)types withHandler:(void(^)(id<OWLAxiom> axiom))handler
{
    [_internals enumerateAxiomsReferencingAnonymousIndividual:individual ofTypes:types withHandler:handler];
}

- (void)enumerateAxiomsReferencingClass:(id<OWLClass>)cls ofTypes:(OWLAxiomType)types withHandler:(void (^)(id<OWLAxiom> axiom))handler
{
    [_internals enumerateAxiomsReferencingClass:cls ofTypes:types withHandler:handler];
}

- (void)enumerateAxiomsReferencingIndividual:(id<OWLIndividual>)individual ofTypes:(OWLAxiomType)types withHandler:(void (^)(id<OWLAxiom> axiom))handler
{
    [_internals enumerateAxiomsReferencingIndividual:individual ofTypes:types withHandler:handler];
}

- (void)enumerateAxiomsReferencingNamedIndividual:(id<OWLNamedIndividual>)individual ofTypes:(OWLAxiomType)types withHandler:(void (^)(id<OWLAxiom> axiom))handler
{
    [_internals enumerateAxiomsReferencingNamedIndividual:individual ofTypes:types withHandler:handler];
}

- (void)enumerateAxiomsReferencingObjectProperty:(id<OWLObjectProperty>)property ofTypes:(OWLAxiomType)types withHandler:(void (^)(id<OWLAxiom> axiom))handler
{
    [_internals enumerateAxiomsReferencingObjectProperty:property ofTypes:types withHandler:handler];
}

#pragma mark Lifecycle

- (instancetype)initWithID:(OWLOntologyID *)ID internals:(OWLOntologyInternals *)internals
{
    NSParameterAssert(ID && internals);
    
    if ((self = [super init])) {
        _ontologyID = [ID copy];
        _internals = internals;
    }
    return self;
}

@end
