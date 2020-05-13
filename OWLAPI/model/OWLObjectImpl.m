//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLCowlUtils.h"
#import "OWLObjCUtils.h"
#import "OWLEntity.h"

#import "cowl_iterator.h"

bool signatureIteratorImpl(void *ctx, CowlEntity entity) {
    void (^handler)(id<OWLEntity> entity) = (__bridge void (^)(__strong id<OWLEntity>))(ctx);
    id<OWLEntity> ent = entityFromCowl(entity, YES);
    if (ent) handler(ent);
    return true;
}

@implementation OWLObjectImpl

#pragma mark NSCopying

- (id)copyWithZone:(__unused NSZone *)zone { return self; }

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity> entity))handler ABSTRACT_METHOD;

- (void)enumerateClassesInSignatureWithHandler:(void (^)(id<OWLClass> owlClass))handler {
    [self enumerateSignatureWithHandler:^(id<OWLEntity> entity) {
        if (entity.entityType == OWLEntityTypeClass) {
            handler((id<OWLClass>)entity);
        }
    }];
}

- (void)enumerateNamedIndividualsInSignatureWithHandler:(void (^)(id<OWLNamedIndividual> ind))handler {
    [self enumerateSignatureWithHandler:^(id<OWLEntity> entity) {
        if (entity.entityType == OWLEntityTypeNamedIndividual) {
            handler((id<OWLNamedIndividual>)entity);
        }
    }];
}

- (void)enumerateObjectPropertiesInSignatureWithHandler:(void (^)(id<OWLObjectProperty> prop))handler {
    [self enumerateSignatureWithHandler:^(id<OWLEntity> entity) {
        if (entity.entityType == OWLEntityTypeObjectProperty) {
            handler((id<OWLObjectProperty>)entity);
        }
    }];
}

#pragma mark - Public methods

@synthesize cowlObject = _cowlObject;

@end
