//
//  OWLObjectPropertyRangeAxiomImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyRangeAxiomImpl.h"

@implementation OWLObjectPropertyRangeAxiomImpl

#pragma mark NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"ObjectPropertyRange(%@ %@)", self.property, self.range];
}

#pragma mark OWLObject

- (NSMutableSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [self.property signature];
    [signature unionSet:[self.range signature]];
    return signature;
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeObjectPropertyRange; }

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLObjectPropertyExpression>)property range:(id<OWLClassExpression>)range
{
    return ((self = [super initWithProperty:property range:range]));
}

@end
