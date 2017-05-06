//
//  Created by Ivano Bilenchi on 16/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAbstractBuilder.h"
#import "OWLClassExpressionBuilderType.h"

@class OWLOntologyBuilder;
@protocol OWLClassExpression;

NS_ASSUME_NONNULL_BEGIN

/// Class expression builder class.
@interface OWLClassExpressionBuilder : NSObject <OWLAbstractBuilder>

#pragma mark Lifecycle

- (instancetype)initWithOntologyBuilder:(OWLOntologyBuilder *)ontologyBuilder;

#pragma mark OWLAbstractBuilder

- (nullable id<OWLClassExpression>)build;

#pragma mark General

/// The type of the built class expression.
DECLARE_BUILDER_VALUE_PROPERTY(OWLCEBType, type, Type)


#pragma mark Class

/// The string representation of the class IRI.
DECLARE_BUILDER_STRING_PROPERTY(classID, ClassID)


#pragma mark Boolean

/// The boolean type of this expression.
DECLARE_BUILDER_VALUE_PROPERTY(OWLCEBBooleanType, booleanType, BooleanType)

/// The operand of this boolean expression (complement).
DECLARE_BUILDER_STRING_PROPERTY(operandID, OperandID)

/// The list identifier of this boolean expression (intersection).
DECLARE_BUILDER_STRING_PROPERTY(listID, ListID)


#pragma mark Restriction

/// The type of the built restriction.
DECLARE_BUILDER_VALUE_PROPERTY(OWLCEBRestrictionType, restrictionType, RestrictionType)

/// Identifier of the property this restriction is about.
DECLARE_BUILDER_STRING_PROPERTY(propertyID, PropertyID)


#pragma mark AllValuesFrom/SomeValuesFrom

/// The filler of this restriction.
DECLARE_BUILDER_STRING_PROPERTY(fillerID, FillerID)


#pragma mark Cardinality

/// The cardinality of the restriction.
DECLARE_BUILDER_STRING_PROPERTY(cardinality, Cardinality)

@end

NS_ASSUME_NONNULL_END
