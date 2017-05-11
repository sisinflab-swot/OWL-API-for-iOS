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
DECLARE_BUILDER_VALUE_PROPERTY(OWLABType, type, Type)


#pragma mark Declarations

/// The type of the declaration axiom to build.
DECLARE_BUILDER_VALUE_PROPERTY(OWLABDeclType, declType, DeclType)


#pragma mark Single statement axioms

/// The ID of the left-hand-side of the axiom.
DECLARE_BUILDER_CSTRING_PROPERTY(LHSID, LHSID)

/// The ID of the middle of the axiom.
DECLARE_BUILDER_CSTRING_PROPERTY(MID, MID)

/// The ID of the right-hand-side of the axiom.
DECLARE_BUILDER_CSTRING_PROPERTY(RHSID, RHSID)

@end

NS_ASSUME_NONNULL_END
