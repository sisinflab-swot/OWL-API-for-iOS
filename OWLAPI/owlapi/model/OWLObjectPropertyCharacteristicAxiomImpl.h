//
//  Created by Ivano Bilenchi on 27/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLLogicalAxiomImpl.h"
#import "OWLObjectPropertyCharacteristicAxiom.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLObjectPropertyCharacteristicAxiom protocol.
@interface OWLObjectPropertyCharacteristicAxiomImpl : OWLLogicalAxiomImpl

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature;

#pragma mark OWLObjectPropertyCharacteristicAxiom

@property (nonatomic, copy, readonly) id<OWLObjectPropertyExpression> property;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLObjectPropertyExpression>)property;

@end

NS_ASSUME_NONNULL_END
