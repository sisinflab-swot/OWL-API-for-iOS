//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
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
 * Gets the signature of this object.
 *
 * @return A set of entities that correspond to the signature of this object.
 */
- (NSMutableSet<id<OWLEntity>> *)signature;

/**
 * A convenience method that obtains the classes that are in the signature of this object.
 *
 * @return A set containing the classes that are in the signature of this object.
 */
- (NSSet<id<OWLClass>> *)classesInSignature;

/**
 * A convenience method that obtains the named individuals that are in the signature of this object.
 *
 * @return A set containing the named individuals that are in the signature of this object.
 */
- (NSSet<id<OWLNamedIndividual>> *)namedIndividualsInSignature;

/**
 * A convenience method that obtains the object properties that are in the signature of this object.
 *
 * @return A set containing the object properties that are in the signature of this object.
 */
- (NSSet<id<OWLObjectProperty>> *)objectPropertiesInSignature;

@end

NS_ASSUME_NONNULL_END
