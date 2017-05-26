//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLDeclarationAxiomImpl.h"
#import "OWLEntity.h"
#import "NSMapTable+SMRObjectCache.h"

@implementation OWLDeclarationAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object { return object == self; }

- (NSUInteger)hash { return (NSUInteger)self; }

- (NSString *)description
{
    return [NSString stringWithFormat:@"Declaration(%@)", _entity];
}

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature { return [_entity signature]; }

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeDeclaration; }

- (BOOL)isAnnotationAxiom { return NO; }

- (BOOL)isLogicalAxiom { return NO; }

#pragma mark OWLDeclarationAxiom

@synthesize entity = _entity;

#pragma mark Other public methods

static NSMapTable *instanceCache = nil;

+ (void)initialize
{
    if (self == [OWLDeclarationAxiomImpl class]) {
        instanceCache = [NSMapTable smr_objCache];
    }
}

- (instancetype)initWithEntity:(id<OWLEntity>)entity
{
    NSParameterAssert(entity);
    
    id cachedInstance = [instanceCache objectForKey:entity];
    
    if (cachedInstance) {
        self = cachedInstance;
    } else if ((self = [super init])) {
        _entity = [(id)entity copy];
        [instanceCache setObject:self forKey:_entity];
    }
    return self;
}

- (void)dealloc { [instanceCache removeObjectForKey:_entity]; }

@end
