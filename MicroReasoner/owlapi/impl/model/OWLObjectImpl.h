//
//  OWLObjectImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"

/**
 * Abstract class that informally implements part of the OWLObject protocol.
 *
 * Subclassing notes:
 * ------------------
 * OWLObject assumes its subclasses to be immutable in order to perform some
 * optimizations (e.g. hash caching and retain on copy).
 * Therefore, the following rules must be followed when subclassing:
 * 
 * Immutable concrete subclasses must override 'isEqual:' and 'computeHash'.
 * Mutable concrete subclasses must override: 'isEqual:', 'hash' and 'copyWithZone:'.
 */
@interface OWLObjectImpl : NSObject <NSCopying>

#pragma mark OWLObject

- (NSSet<id<OWLClass>> *)classesInSignature;
- (NSSet<id<OWLNamedIndividual>> *)namedIndividualsInSignature;
- (NSSet<id<OWLObjectProperty>> *)objectPropertiesInSignature;

#pragma mark Other abstract methods

- (NSUInteger)computeHash;

@end
