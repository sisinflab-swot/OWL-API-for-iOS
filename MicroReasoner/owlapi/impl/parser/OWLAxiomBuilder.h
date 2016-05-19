//
//  OWLAxiomBuilder.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAbstractBuilder.h"
#import "OWLAxiomBuilderType.h"

@protocol OWLAxiom;
@class OWLOntologyBuilder;

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

#pragma mark Binary class expression axioms

// Used in binary class expression axioms, such as:
// subclass, disjoint classes, equivalent classes

/// The ID of the left-hand-side class expression.
@property (nonatomic, copy, readonly) NSString *LHSClassID;

/// Sets the ID of the left-hand-side class expression.
- (BOOL)setLHSClassID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

/// The ID of the right-hand-side class expression.
@property (nonatomic, copy, readonly) NSString *RHSClassID;

/// Sets the ID of the right-hand-side class expression.
- (BOOL)setRHSClassID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

#pragma mark Property domain and range

/// The ID of the property expression this axiom is about.
@property (nonatomic, copy, readonly) NSString *propertyID;

/// Sets the ID of the property expression this axiom is about.
- (BOOL)setPropertyID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

/// The ID of the class expression that acts as domain/range.
@property (nonatomic, copy, readonly) NSString *domainRangeID;

/// Sets the ID of the class expression that acts as domain/range.
- (BOOL)setDomainRangeID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

NS_ASSUME_NONNULL_END

@end
