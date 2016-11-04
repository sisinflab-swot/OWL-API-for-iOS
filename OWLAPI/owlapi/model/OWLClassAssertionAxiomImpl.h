//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLLogicalAxiomImpl.h"
#import "OWLClassAssertionAxiom.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLClassAssertionAxiomImpl : OWLLogicalAxiomImpl <OWLClassAssertionAxiom>

- (instancetype)initWithIndividual:(id<OWLIndividual>)individual
                   classExpression:(id<OWLClassExpression>)classExpression;

@end

NS_ASSUME_NONNULL_END
