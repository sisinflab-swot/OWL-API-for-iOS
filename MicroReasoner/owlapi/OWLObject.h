//
//  OWLObject.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OWLClass;

NS_ASSUME_NONNULL_BEGIN

/// Represents a generic OWL object.
@protocol OWLObject <NSObject>

/**
 * A convenience method that obtains the classes that are in the signature of this object.
 *
 * @return A set containing the classes that are in the signature of this object.
 */
- (NSSet<id<OWLClass>> *)getClassesInSignature;

@end

NS_ASSUME_NONNULL_END
