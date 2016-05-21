//
//  OWLDeclarationAxiomImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLDeclarationAxiomImpl.h"
#import "OWLEntity.h"

@implementation OWLDeclarationAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        id objEntity = [object entity];
        id selfEntity = self.entity;
        
        equal = (objEntity == selfEntity || [objEntity isEqual:selfEntity]);
    }
    
    return equal;
}

- (NSUInteger)computeHash { return [self.entity hash]; }

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature { return [self.entity signature]; }

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeDeclaration; }

- (BOOL)isAnnotationAxiom { return NO; }

- (BOOL)isLogicalAxiom { return NO; }

#pragma mark OWLDeclarationAxiom

@synthesize entity = _entity;

#pragma mark Other public methods

- (instancetype)initWithEntity:(id<OWLEntity>)entity
{
    NSParameterAssert(entity);
    
    if ((self = [super init])) {
        _entity = [(id)entity copy];
    }
    
    return self;
}

@end
