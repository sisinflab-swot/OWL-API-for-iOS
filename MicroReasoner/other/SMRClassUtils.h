//
//  SMRClassUtils.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

/**
 * Use this directive to mark method implementations that should be overridden
 * by concrete subclasses.
 */
#define ABSTRACT_METHOD {\
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
reason:@"This method should be overridden in a subclass." \
userInfo:nil]; \
}

/**
 * Use this directive in place of @synthesize to automatically create a
 * lazy getter for the specified property. Example syntax:
 *
 * SYNTHESIZE_LAZY(NSMutableString, myMutableString) {
 *     return [NSMutableString stringWithString:@"my mutable string"];
 * }
 *
 * @param type The type of the property.
 * @param name The name of the property.
 */
#define SYNTHESIZE_LAZY(type, name) \
@synthesize name = _##name; \
- (type *)name { \
if (_##name == nil) { _##name = [self __##name##LazyInit]; } \
return _##name; \
} \
- (type *)__##name##LazyInit

/**
 * Use this directive in place of @synthesize to automatically create a
 * lazy getter for the specified property. The getter calls the default
 * 'init' constructor.
 *
 * @param type The type of the property.
 * @param name The name of the property.
 */
#define SYNTHESIZE_LAZY_INIT(type, name) \
@synthesize name = _##name; \
- (type *)name { \
if (_##name == nil) { _##name = [[type alloc] init]; } \
return _##name; \
}
