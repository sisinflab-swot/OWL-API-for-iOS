//
//  Created by Ivano Bilenchi on 22/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLIndividualRelationshipAxiomImpl.h"
#import "OWLObjectPropertyAssertionAxiom.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLObjectPropertyAssertionAxiomImpl : OWLIndividualRelationshipAxiomImpl <OWLObjectPropertyAssertionAxiom>

#pragma mark OWLIndividualRelationshipAxiomImpl

- (instancetype)initWithSubject:(id<OWLIndividual>)subject property:(id<OWLObjectPropertyExpression>)property object:(id<OWLIndividual>)object;

@end

NS_ASSUME_NONNULL_END
