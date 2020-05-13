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
 * SYNTHESIZE_LAZY(NSMutableString, myMutableString, {
 *     _myMutableString = [NSMutableString stringWithString:@"my mutable string"];
 * })
 *
 * @param type The type of the property.
 * @param name The name of the property.
 * @param body The body of the lazy setter.
 */
#define SYNTHESIZE_LAZY(TYPE, NAME, BODY) \
@synthesize NAME = _##NAME; \
- (TYPE *)NAME { \
    if (_##NAME == nil) BODY \
    return _##NAME; \
}

/**
 * Use this directive in place of @synthesize to automatically create a
 * lazy getter for the specified property. The getter calls the default
 * 'init' constructor.
 *
 * @param type The type of the property.
 * @param name The name of the property.
 */
#define SYNTHESIZE_LAZY_INIT(TYPE, NAME) \
@synthesize NAME = _##NAME; \
- (TYPE *)NAME { \
    if (_##NAME == nil) { _##NAME = [[TYPE alloc] init]; } \
    return _##NAME; \
}

/**
 * Use this directive to check whether a bitmask has a specific bit set.
 *
 * @param OPTIONS The bitmask.
 * @param OPTION The bit to check.
 *
 * @return True if the bit is set, false otherwise.
 */
#define has_option(OPTIONS, OPTION) ((OPTIONS & OPTION) == OPTION)
