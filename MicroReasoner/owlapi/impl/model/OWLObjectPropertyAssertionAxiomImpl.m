//
//  OWLObjectPropertyAssertionAxiomImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 22/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyAssertionAxiomImpl.h"

@implementation OWLObjectPropertyAssertionAxiomImpl

#pragma mark OWLObject

- (NSMutableSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [self.subject signature];
    [signature unionSet:[self.property signature]];
    [signature unionSet:[self.object signature]];
    return signature;
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeObjectPropertyAssertion; }

#pragma mark OWLIndividualRelationshipAxiomImpl

- (instancetype)initWithSubject:(id<OWLIndividual>)subject property:(id<OWLObjectPropertyExpression>)property object:(id<OWLIndividual>)object
{
    return ((self = [super initWithSubject:subject property:property object:object]));
}

@end
