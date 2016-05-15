//
//  OWLObjectPropertyRangeAxiomImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLPropertyRangeAxiomImpl.h"
#import "OWLObjectPropertyRangeAxiom.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLObjectPropertyRangeAxiomImpl : OWLPropertyRangeAxiomImpl <OWLObjectPropertyRangeAxiom>

- (instancetype)initWithProperty:(id<OWLObjectPropertyExpression>)property range:(id<OWLClassExpression>)range;

@end

NS_ASSUME_NONNULL_END
