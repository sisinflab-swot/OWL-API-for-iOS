//
//  OWLPropertyBuilder.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAbstractBuilder.h"

@protocol OWLProperty;

typedef NS_ENUM(NSInteger, OWLPBType) {
    OWLPBTypeUnknown,
    OWLPBTypeObjectProperty
};

typedef NS_ENUM(NSInteger, OWLPBNamed) {
    OWLPBNamedUnknown,
    OWLPBNamedYes,
    OWLPBNamedNo
};

NS_ASSUME_NONNULL_BEGIN

/// Property builder class.
@interface OWLPropertyBuilder : NSObject <OWLAbstractBuilder>

#pragma mark OWLAbstractBuilder

- (nullable id<OWLProperty>)build;

#pragma mark General

/// The type of the built property.
@property (nonatomic, readonly) OWLPBType type;

/**
 * Sets the type of the built property.
 *
 * @return NO if the type was already set, YES otherwise.
 */
- (BOOL)setType:(OWLPBType)type error:(NSError *_Nullable __autoreleasing *)error;

#pragma mark Named properties

/// The string representation of the property IRI.
@property (nonatomic, readonly) NSString *namedPropertyID;

/**
 * Sets the string representation of the property IRI.
 *
 * @return NO if the ID was already set, YES otherwise.
 */
- (BOOL)setNamedPropertyID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
