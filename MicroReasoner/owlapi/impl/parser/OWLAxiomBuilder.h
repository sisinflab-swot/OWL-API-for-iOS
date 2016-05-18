//
//  OWLAxiomBuilder.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAbstractBuilder.h"

@protocol OWLAxiom;
@class OWLOntologyBuilder;

typedef NS_ENUM(NSInteger, OWLABType) {
    OWLABTypeUnknown,
    OWLABTypeDeclaration,
    OWLABTypeSubClassOf
};

NS_ASSUME_NONNULL_BEGIN

/// Axiom builder class.
@interface OWLAxiomBuilder : NSObject <OWLAbstractBuilder>

#pragma mark Lifecycle

- (instancetype)initWithOntologyBuilder:(OWLOntologyBuilder *)builder;

#pragma mark OWLAbstractBuilder

- (nullable id<OWLAxiom>)build;

#pragma mark General

/// The type of the built axiom.
@property (nonatomic, readonly) OWLABType type;

/// Sets the type of the built axiom.
- (BOOL)setType:(OWLABType)type error:(NSError *_Nullable __autoreleasing *)error;

#pragma mark Declaration axioms

/// The string representation of the entity IRI.
@property (nonatomic, copy, readonly) NSString *entityID;

/// Sets the string representation of the entity IRI.
- (BOOL)setEntityID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

#pragma mark SubClassOf axioms

/// The ID of the superclass.
@property (nonatomic, copy, readonly) NSString *superClassID;

/// Sets the ID of the superclass.
- (BOOL)setSuperClassID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

/// The ID of the subclass.
@property (nonatomic, copy, readonly) NSString *subClassID;

/// Sets the ID of the subclass.
- (BOOL)setSubClassID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

NS_ASSUME_NONNULL_END

@end
