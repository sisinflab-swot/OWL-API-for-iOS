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

- (NSSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [[NSMutableSet alloc] initWithSet:[self.subject signature]];
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
