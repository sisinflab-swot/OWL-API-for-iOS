//
//  OWLPropertyDomainAxiomImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLPropertyDomainAxiomImpl.h"
#import "OWLClassExpression.h"
#import "OWLPropertyExpression.h"

@implementation OWLPropertyDomainAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        id objDomain = [(id<OWLPropertyDomainAxiom>)object domain];
        id selfDomain = self.domain;
        
        equal = (objDomain == selfDomain || [objDomain isEqual:selfDomain]);
    }
    
    return equal;
}

- (NSUInteger)hash { return [self.property hash] ^ [self.domain hash]; }

#pragma mark OWLPropertyDomainAxiom

@synthesize domain = _domain;

#pragma mark Other public methods

- (instancetype)initWithProperty:(id<OWLPropertyExpression>)property domain:(id<OWLClassExpression>)domain
{
    NSParameterAssert(domain);
    
    if ((self = [super initWithProperty:property])) {
        _domain = [(id)domain copy];
    }
    return self;
}

@end