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

#pragma mark Single statement axioms

/// The ID of the left-hand-side of the axiom.
@property (nonatomic, copy, readonly) NSString *LHSID;

/// Sets the ID of the left-hand-side of the axiom.
- (BOOL)setLHSID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

/// The ID of the right-hand-side of the axiom.
@property (nonatomic, copy, readonly) NSString *RHSID;

/// Sets the ID of the right-hand-side of the axiom.
- (BOOL)setRHSID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

NS_ASSUME_NONNULL_END

@end
