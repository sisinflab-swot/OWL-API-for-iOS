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

/**
 * Sets the type of the built class expression.
 *
 * @return NO if the type was already set, YES otherwise.
 */
- (BOOL)setType:(OWLCEBType)type error:(NSError *_Nullable __autoreleasing *)error;

#pragma mark Class

/// The string representation of the class IRI.
@property (nonatomic, copy, readonly) NSString *classID;

/**
 * Sets the string representation of the class IRI.
 *
 * @return NO if the ID was already set, YES otherwise.
 */
- (BOOL)setClassID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

#pragma mark Restriction

/// The type of the built restriction.
@property (nonatomic, readonly) OWLCEBRestrictionType restrictionType;

/**
 * Sets the type of the built restriction.
 *
 * @return NO if the type was already set, YES otherwise.
 */
- (BOOL)setRestrictionType:(OWLCEBRestrictionType)type error:(NSError *_Nullable __autoreleasing *)error;

/// Identifier of the property this restriction is about.
@property (nonatomic, copy, readonly) NSString *propertyID;

/**
 * Sets the the property the restriction is about.
 *
 * @return NO if the ID was already set, YES otherwise.
 */
- (BOOL)setPropertyID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

/// The filler of this restriction.
@property (nonatomic, copy, readonly) NSString *fillerID;

/**
 * Sets the the filler of the restriction.
 *
 * @return NO if the ID was already set, YES otherwise.
 */
- (BOOL)setFillerID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
