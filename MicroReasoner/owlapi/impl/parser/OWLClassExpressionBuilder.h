//
//  OWLClassExpressionBuilder.h
//  MicroReasoner
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
@property (nonatomic, readonly) OWLCEBType type;

/// Sets the type of the built class expression.
- (BOOL)setType:(OWLCEBType)type error:(NSError *_Nullable __autoreleasing *)error;

#pragma mark Class

/// The string representation of the class IRI.
@property (nonatomic, copy, readonly) NSString *classID;

/// Sets the string representation of the class IRI.
- (BOOL)setClassID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

#pragma mark Boolean

/// The boolean type of this expression.
@property (nonatomic, readonly) OWLCEBBooleanType booleanType;

/// Sets the boolean type of this expression.
- (BOOL)setBooleanType:(OWLCEBBooleanType)type error:(NSError *_Nullable __autoreleasing *)error;

/// The list identifier of this boolean expression.
@property (nonatomic, copy, readonly) NSString *listID;

// Sets the list identifier of this boolean expression.
- (BOOL)setListID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

#pragma mark Restriction

/// The type of the built restriction.
@property (nonatomic, readonly) OWLCEBRestrictionType restrictionType;

/// Sets the type of the built restriction.
- (BOOL)setRestrictionType:(OWLCEBRestrictionType)type error:(NSError *_Nullable __autoreleasing *)error;

/// Identifier of the property this restriction is about.
@property (nonatomic, copy, readonly) NSString *propertyID;

/// Sets the the property the restriction is about.
- (BOOL)setPropertyID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

#pragma mark AllValuesFrom/SomeValuesFrom

/// The filler of this restriction.
@property (nonatomic, copy, readonly) NSString *fillerID;

/// Sets the the filler of the restriction.
- (BOOL)setFillerID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

#pragma mark Cardinality

/// The cardinality of the restriction.
@property (nonatomic, copy, readonly) NSString *cardinality;

/// Sets the cardinality of the restriction.
- (BOOL)setCardinality:(NSString *)cardinality error:(NSError *_Nullable __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
