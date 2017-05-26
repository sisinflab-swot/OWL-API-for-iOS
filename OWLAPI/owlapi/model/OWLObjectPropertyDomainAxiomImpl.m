//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyDomainAxiomImpl.h"
#import "OWLClassExpression.h"

@implementation OWLObjectPropertyDomainAxiomImpl

#pragma mark NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"ObjectPropertyDomain(%@ %@)", self.property, self.domain];
}

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = (NSMutableSet *)[self.property signature];
    [signature unionSet:[self.domain signature]];
    return signature;
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeObjectPropertyDomain; }

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLObjectPropertyExpression>)property domain:(id<OWLClassExpression>)domain
{
    return ((self = [super initWithProperty:property domain:domain]));
}

@end
