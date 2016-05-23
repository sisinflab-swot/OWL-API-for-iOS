//
//  RDFObject.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 23/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Wraps librdf C objects.
@interface RDFObject : NSObject
{
    @protected
    void *_wrappedObject;
    BOOL _owner;
}

/**
 * A convenience initializer. Same as 'initWithWrappedObject:owner:'
 * with 'owner' set to YES.
 *
 * @param object The librdf object to wrap.
 *
 * @return An initialized RDFObject instance.
 */
- (id)initWithWrappedObject:(void *)object;

/**
 * The designated initializer.
 *
 * @param object The librdf object to wrap.
 * @param owner If YES, this object should free the wrapped object on dealloc.
 *
 * @return An initialized RDFObject instance.
 */
- (id)initWithWrappedObject:(void *)object owner:(BOOL)owner;

NS_ASSUME_NONNULL_END

@end
