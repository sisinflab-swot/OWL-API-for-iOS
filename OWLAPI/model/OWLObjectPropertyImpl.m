//
//  Created by Ivano Bilenchi on 08/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyImpl.h"
#import "OWLCowlUtils.h"
#import "OWLIRI+Private.h"
#import "cowl_obj_prop.h"

@implementation OWLObjectPropertyImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_obj_prop_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return (NSUInteger)cowl_obj_prop_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_obj_prop_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    handler(self);
}

#pragma mark OWLNamedObject

- (OWLIRI *)IRI {
    return [[OWLIRI alloc] initWithCowlIRI:cowl_obj_prop_get_iri(_cowlObject) retain:NO];
}

#pragma mark OWLEntity

- (OWLEntityType)entityType { return OWLEntityTypeObjectProperty; }

- (BOOL)isOWLClass { return NO; }

- (BOOL)isOWLNamedIndividual { return NO; }

- (BOOL)isOWLObjectProperty { return YES; }

#pragma mark OWLIdentifiedEntity

- (OWLEntityID)identifier { return (OWLEntityID)_cowlObject; }

#pragma mark OWLPropertyExpression

- (BOOL)anonymous { return NO; }

#pragma mark OWLObjectPropertyExpression

- (id<OWLObjectProperty>)asOWLObjectProperty { return self; }

#pragma mark Lifecycle

- (instancetype)initWithCowlProperty:(CowlObjProp *)cowlProp retain:(BOOL)retain {
    NSParameterAssert(cowlProp);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_obj_prop_retain(cowlProp) : cowlProp;
    }
    return self;
}

- (instancetype)initWithIRI:(OWLIRI *)IRI
{
    NSParameterAssert(IRI);
    return [self initWithCowlProperty:cowl_obj_prop_get(IRI.cowlIRI) retain:NO];
}

- (void)dealloc { cowl_obj_prop_release(_cowlObject); }

@end
