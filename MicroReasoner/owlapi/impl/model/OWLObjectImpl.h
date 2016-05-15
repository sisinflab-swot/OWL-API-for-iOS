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
 * Subclassing note: concrete subclasses must override 'isEqual:' and 'hash'.
 * Furthermore, subclasses are expected to be immutable. If, however, a
 * mutable subclass is required, the user must also override 'copyWithZone:'.
 */
@interface OWLObjectImpl : NSObject <NSCopying>

#pragma mark OWLObject

- (NSSet<id<OWLClass>> *)classesInSignature;
- (NSSet<id<OWLNamedIndividual>> *)namedIndividualsInSignature;
- (NSSet<id<OWLObjectProperty>> *)objectPropertiesInSignature;

@end
