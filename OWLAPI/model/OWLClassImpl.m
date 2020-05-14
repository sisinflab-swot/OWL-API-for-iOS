//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLClassImpl.h"
#import "OWLCowlUtils.h"
#import "OWLDisjointClassesAxiom.h"
#import "OWLEquivalentClassesAxiom.h"
#import "OWLIRI+Private.h"
#import "OWLOntology.h"
#import "OWLSubClassOfAxiom.h"

#import "cowl_class.h"
#import "cowl_owl_vocab.h"

@implementation OWLClassImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_class_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return (NSUInteger)cowl_class_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_class_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    handler(self);
}

#pragma mark OWLNamedObject

- (OWLIRI *)IRI {
    return [[OWLIRI alloc] initWithCowlIRI:cowl_class_get_iri(_cowlObject) retain:YES];
}

#pragma mark OWLEntity

- (OWLEntityType)entityType { return OWLEntityTypeClass; }

- (BOOL)isOWLClass { return YES; }

- (BOOL)isOWLNamedIndividual { return NO; }

- (BOOL)isOWLObjectProperty { return NO; }

#pragma mark OWLIdentifiedEntity

- (OWLEntityID)identifier { return (OWLEntityID)_cowlObject; }

+ (id<OWLIdentifiedEntity>)entityWithIdentifier:(OWLEntityID)identifier {
    return [[self alloc] initWithCowlClass:(CowlClass *)identifier retain:NO];
}

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType { return OWLClassExpressionTypeClass; }

- (BOOL)anonymous { return NO; }

- (BOOL)isOWLThing { return cowl_class_equals(_cowlObject, cowl_owl_vocab_get()->cls.thing); }

- (BOOL)isOWLNothing { return cowl_class_equals(_cowlObject, cowl_owl_vocab_get()->cls.nothing); }

- (NSSet<id<OWLClassExpression>> *)asConjunctSet { return [NSSet setWithObject:self]; }

- (id<OWLClass>)asOwlClass { return self; }

#pragma mark Lifecycle

- (instancetype)initWithCowlClass:(CowlClass *)cowlClass retain:(BOOL)retain {
    NSParameterAssert(cowlClass);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_class_retain(cowlClass) : cowlClass;
    }
    return self;
}

- (instancetype)initWithIRI:(OWLIRI *)IRI
{
    NSParameterAssert(IRI);
    return [self initWithCowlClass:cowl_class_get(IRI.cowlIRI) retain:NO];
}

- (void)dealloc { cowl_class_release(_cowlObject); }

@end
