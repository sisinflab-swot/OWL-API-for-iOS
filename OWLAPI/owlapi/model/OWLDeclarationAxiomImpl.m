//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLDeclarationAxiomImpl.h"
#import "OWLCowlUtils.h"
#import "OWLEntity.h"
#import "cowl_decl_axiom.h"

@implementation OWLDeclarationAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_decl_axiom_equals(_cowlObject, ((OWLObjectImpl *)object)->_cowlObject);
}

- (NSUInteger)hash { return cowl_decl_axiom_hash(_cowlObject); }

- (NSString *)description {
    return stringFromCowl(cowl_decl_axiom_to_string(_cowlObject), YES);
}

#pragma mark OWLObject

- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity>))handler {
    return [self.entity enumerateSignatureWithHandler:handler];
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeDeclaration; }

- (BOOL)isAnnotationAxiom { return NO; }

- (BOOL)isLogicalAxiom { return NO; }

#pragma mark OWLDeclarationAxiom

- (id<OWLEntity>)entity {
    return entityFromCowl(cowl_decl_axiom_get_entity(_cowlObject), YES);
}

#pragma mark Other public methods

- (instancetype)initWithCowlAxiom:(CowlDeclAxiom *)axiom retain:(BOOL)retain {
    NSParameterAssert(axiom);
    if ((self = [super init])) {
        _cowlObject = retain ? cowl_decl_axiom_retain(axiom) : axiom;
    }
    return self;
}

- (instancetype)initWithEntity:(id<OWLEntity>)entity
{
    NSParameterAssert(entity);
    CowlDeclAxiom *axiom = cowl_decl_axiom_get(cowlEntityFrom(entity), NULL);
    return [self initWithCowlAxiom:axiom retain:NO];
}

- (void)dealloc { cowl_decl_axiom_release(_cowlObject); }

@end
