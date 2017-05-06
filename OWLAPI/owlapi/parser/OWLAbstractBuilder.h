//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Use this directive to declare a NSString property for a builder.
 *
 * @param NAME Name of the property.
 * @param ACCESSOR_NAME Name that the property should have in its accessors.
 */
#define DECLARE_BUILDER_STRING_PROPERTY(NAME, ACCESSOR_NAME) \
@property (nonatomic, copy, readonly, nullable) NSString *NAME; \
- (BOOL)set##ACCESSOR_NAME:(NSString *)NAME error:(NSError *_Nullable __autoreleasing *)error;

/**
 * Use this directive in place of @synthesize to automatically create
 * accessor methods for a NSString property of a builder.
 *
 * @param NAME Name of the property.
 * @param ACCESSOR_NAME Name that the property should have in its accessors.
 * @param ERROR_DESC Description of the error triggered upon setting the property twice.
 */
#define SYNTHESIZE_BUILDER_STRING_PROPERTY(NAME, ACCESSOR_NAME, ERROR_DESC) \
@synthesize NAME = _##NAME; \
- (BOOL)set##ACCESSOR_NAME:(NSString *)NAME error:(NSError *__autoreleasing *)error \
{ \
    if (_##NAME == NAME || [_##NAME isEqualToString:NAME]) { \
        return YES; \
    } \
    if (!_##NAME) { \
        _##NAME = [NAME copy]; \
        return YES; \
    } \
    if (error) { \
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax \
                      localizedDescription:ERROR_DESC \
                                  userInfo:@{@"Values": @[_##NAME, NAME]}]; \
    } \
    return NO; \
}

/**
 * Use this directive to declare a value property for a builder.
 *
 * @param TYPE Type of the property.
 * @param NAME Name of the property.
 * @param ACCESSOR_NAME Name that the property should have in its accessors.
 */
#define DECLARE_BUILDER_VALUE_PROPERTY(TYPE, NAME, ACCESSOR_NAME) \
@property (nonatomic, readonly) TYPE NAME; \
- (BOOL)set##ACCESSOR_NAME:(TYPE)NAME error:(NSError *_Nullable __autoreleasing *)error;

/**
 * Use this directive in place of @synthesize to automatically create
 * accessor methods for a value property of a builder.
 *
 * @param TYPE Type of the property.
 * @param NAME Name of the property.
 * @param ACCESSOR_NAME Name that the property should have in its accessors.
 * @param ERROR_DESC Description of the error triggered upon setting the property twice.
 */
#define SYNTHESIZE_BUILDER_VALUE_PROPERTY(TYPE, NAME, ACCESSOR_NAME, ERROR_DESC) \
@synthesize NAME = _##NAME; \
- (BOOL)set##ACCESSOR_NAME:(TYPE)NAME error:(NSError *__autoreleasing *)error \
{ \
    if (_##NAME == NAME) { \
        return YES; \
    } \
    if (_##NAME == 0) { \
        _##NAME = NAME; \
        return YES; \
    } \
    if (error) { \
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax \
                      localizedDescription:ERROR_DESC \
                                  userInfo:@{@"Values": @[@(_##NAME), @(NAME)]}]; \
    } \
    return NO; \
}

NS_ASSUME_NONNULL_BEGIN

@protocol OWLAbstractBuilder <NSObject>

- (nullable id)build;

@end

NS_ASSUME_NONNULL_END
