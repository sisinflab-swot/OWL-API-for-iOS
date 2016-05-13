//
//  OWLObjectImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLEntity.h"
#import "SMRPreprocessor.h"

@implementation OWLObjectImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object { return object == self || [object isKindOfClass:[self class]]; }

- (NSUInteger)hash { return 0; }

#pragma mark NSCopying

// This object is immutable.
- (id)copyWithZone:(__unused NSZone *)zone { return self; }

#pragma mark OWLObject

- (NSSet<id<OWLClass>> *)classesInSignature
{
    NSMutableSet<id<OWLClass>> *classes = [[NSMutableSet alloc] init];
    for (id<OWLEntity> entity in self.signature) {
        if (entity.isOWLClass) {
            [classes addObject:(id<OWLClass>)entity];
        }
    }
    return classes;
}

- (NSSet<id<OWLObjectProperty>> *)objectPropertiesInSignature
{
    NSMutableSet<id<OWLObjectProperty>> *properties = [[NSMutableSet alloc] init];
    for (id<OWLEntity> entity in self.signature) {
        if (entity.isOWLObjectProperty) {
            [properties addObject:(id<OWLObjectProperty>)entity];
        }
    }
    return properties;
}

- (NSSet<id<OWLEntity>> *)signature ABSTRACT_METHOD;

@end
