//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OWLClass;
@protocol OWLEntity;
@protocol OWLNamedIndividual;
@protocol OWLObjectProperty;

NS_ASSUME_NONNULL_BEGIN

/// Represents a generic OWL object.
@protocol OWLObject <NSObject, NSCopying>

/**
 * Enumerates over the signature of this object.
 *
 * @param handler The enumeration handler.
 */
- (void)enumerateSignatureWithHandler:(void (^)(id<OWLEntity> entity))handler;

/**
 * Enumerates over the classes present in the signature of this object.
 *
 * @param handler The enumeration handler.
 */
- (void)enumerateClassesInSignatureWithHandler:(void (^)(id<OWLClass> owlClass))handler;

/**
 * Enumerates over the named individuals present in the signature of this object.
 *
 * @param handler The enumeration handler.
*/
- (void)enumerateNamedIndividualsInSignatureWithHandler:(void (^)(id<OWLNamedIndividual> ind))handler;


/**
 * Enumerates over the object properties present in the signature of this object.
 *
 * @param handler The enumeration handler.
*/
- (void)enumerateObjectPropertiesInSignatureWithHandler:(void (^)(id<OWLObjectProperty> prop))handler;

@end

NS_ASSUME_NONNULL_END
