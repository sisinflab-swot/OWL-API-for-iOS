//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLEntity.h"
#import "SMRClassUtils.h"

@interface OWLObjectImpl ()
{
    BOOL _hasCachedHash;
    NSUInteger _cachedHash;
}
@end


@implementation OWLObjectImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object { return object == self || [object isKindOfClass:[self class]]; }

- (NSUInteger)hash
{
    if (!_hasCachedHash) {
        _cachedHash = [self computeHash];
        _hasCachedHash = YES;
    }
    return _cachedHash;
}

#pragma mark NSCopying

// This object is immutable.
- (id)copyWithZone:(__unused NSZone *)zone { return self; }

#pragma mark OWLObject

- (NSSet<id<OWLClass>> *)classesInSignature { return [self entitiesInSignatureOfType:OWLEntityTypeClass]; }

- (NSSet<id<OWLNamedIndividual>> *)namedIndividualsInSignature { return [self entitiesInSignatureOfType:OWLEntityTypeNamedIndividual]; }

- (NSSet<id<OWLObjectProperty>> *)objectPropertiesInSignature { return [self entitiesInSignatureOfType:OWLEntityTypeObjectProperty]; }

- (NSMutableSet<id<OWLEntity>> *)signature ABSTRACT_METHOD;

#pragma mark Other abstract methods

- (NSUInteger)computeHash ABSTRACT_METHOD;

#pragma mark Private methods

- (NSSet *)entitiesInSignatureOfType:(OWLEntityType)type
{
    NSMutableSet *entities = [[NSMutableSet alloc] init];
    for (id<OWLEntity> entity in self.signature) {
        if (entity.entityType == type) {
            [entities addObject:entity];
        }
    }
    return entities;
}

@end
