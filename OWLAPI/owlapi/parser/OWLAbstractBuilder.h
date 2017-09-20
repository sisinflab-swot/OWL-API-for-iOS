//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OWLAbstractBuilder <NSObject>

- (nullable id)build;

@end

NS_ASSUME_NONNULL_END


#pragma mark Builder property generators

/**
 * Use this directive to declare a NSString property for a builder.
 *
 * @param NAME Name of the property.
 * @param ACCESSOR_NAME Name that the property should have in its accessors.
 */
#define DECLARE_BUILDER_STRING_PROPERTY(NAME, ACCESSOR_NAME) \
__DECLARE_BUILDER_OBJ_PROPERTY(NSString, NAME, ACCESSOR_NAME)

/**
 * Use this directive in place of @synthesize to automatically create
 * accessor methods for a NSString property of a builder.
 *
 * @param NAME Name of the property.
 * @param ACCESSOR_NAME Name that the property should have in its accessors.
 * @param ERROR_DESC Description of the error triggered upon setting the property twice.
 */
#define SYNTHESIZE_BUILDER_STRING_PROPERTY(NAME, ACCESSOR_NAME, ERROR_DESC) \
__SYNTHESIZE_BUILDER_OBJ_PROPERTY(NSString, NAME, ACCESSOR_NAME, isEqualToString, ERROR_DESC)

/**
 * Use this directive to declare an unsigned char * property for a builder.
 *
 * @param NAME Name of the property.
 * @param ACCESSOR_NAME Name that the property should have in its accessors.
 */
#define DECLARE_BUILDER_CSTRING_PROPERTY(NAME, ACCESSOR_NAME) \
@property (nonatomic, readonly, nullable) unsigned char *NAME; \
- (BOOL)set##ACCESSOR_NAME:(unsigned char *)NAME error:(NSError *_Nullable __autoreleasing *)error;

/**
 * Use this directive in place of @synthesize to automatically create
 * accessor methods for an unsigned char * property of a builder.
 *
 * @param NAME Name of the property.
 * @param ACCESSOR_NAME Name that the property should have in its accessors.
 * @param ERROR_DESC Description of the error triggered upon setting the property twice.
 */
#define SYNTHESIZE_BUILDER_CSTRING_PROPERTY(NAME, ACCESSOR_NAME, ERROR_DESC) \
@synthesize NAME = _##NAME; \
- (BOOL)set##ACCESSOR_NAME:(unsigned char *)NAME error:(NSError *__autoreleasing *)error \
{ \
    if (_##NAME == NAME || _##NAME && strcmp((char *)_##NAME, (char *)NAME) == 0) { \
        return YES; \
    } \
    if (!_##NAME) { \
        _##NAME = (unsigned char *)strdup((char *)NAME); \
        return YES; \
    } \
    if (error) { \
        NSString *curValue = [NSString stringWithUTF8String:(char *)_##NAME] ?: @"nil"; \
        NSString *newValue = [NSString stringWithUTF8String:(char *)NAME] ?: @"nil"; \
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax \
                      localizedDescription:ERROR_DESC \
                      userInfo:@{@"Values": @[curValue, newValue]}]; \
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


#pragma mark Private property generators

/**
 * Use this directive to declare an Objective-C property for a builder.
 *
 * @param TYPE Type of the property.
 * @param NAME Name of the property.
 * @param ACCESSOR_NAME Name that the property should have in its accessors.
 */
#define __DECLARE_BUILDER_OBJ_PROPERTY(TYPE, NAME, ACCESSOR_NAME) \
@property (nonatomic, copy, readonly, nullable) TYPE *NAME; \
- (BOOL)set##ACCESSOR_NAME:(TYPE *)NAME error:(NSError *_Nullable __autoreleasing *)error;

/**
 * Use this directive in place of @synthesize to automatically create
 * accessor methods for an Objective-C property of a builder.
 *
 * @param TYPE Type of the property.
 * @param NAME Name of the property.
 * @param ACCESSOR_NAME Name that the property should have in its accessors.
 * @param EQUALS Name of the equality method to use.
 * @param ERROR_DESC Description of the error triggered upon setting the property twice.
 */
#define __SYNTHESIZE_BUILDER_OBJ_PROPERTY(TYPE, NAME, ACCESSOR_NAME, EQUALS, ERROR_DESC) \
@synthesize NAME = _##NAME; \
- (BOOL)set##ACCESSOR_NAME:(TYPE *)NAME error:(NSError *__autoreleasing *)error \
{ \
    if (_##NAME == NAME || [_##NAME EQUALS:NAME]) { \
        return YES; \
    } \
    if (!_##NAME) { \
        _##NAME = [NAME copy]; \
        return YES; \
    } \
    if (error) { \
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax \
                      localizedDescription:ERROR_DESC \
                      userInfo:@{@"Values": @[_##NAME ?: @"nil", NAME ?: @"nil"]}]; \
    } \
    return NO; \
}
