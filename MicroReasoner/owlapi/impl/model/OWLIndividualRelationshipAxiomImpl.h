//
//  OWLIndividualRelationshipAxiomImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 22/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLLogicalAxiomImpl.h"
#import "OWLPropertyAssertionAxiom.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLPropertyAssertionAxiom protocol.
@interface OWLIndividualRelationshipAxiomImpl : OWLLogicalAxiomImpl

#pragma mark OWLPropertyAssertionAxiom

@property (nonatomic, copy, readonly) id<OWLIndividual> subject;
@property (nonatomic, copy, readonly) id<OWLPropertyExpression> property;
@property (nonatomic, copy, readonly) id<OWLPropertyAssertionObject> object;

#pragma mark Other public methods

- (instancetype)initWithSubject:(id<OWLIndividual>)subject
                       property:(id<OWLPropertyExpression>)property
                         object:(id<OWLPropertyAssertionObject>)object;

@end

NS_ASSUME_NONNULL_END
