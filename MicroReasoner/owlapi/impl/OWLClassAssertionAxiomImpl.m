//
//  OWLClassAssertionAxiomImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClassAssertionAxiomImpl.h"
#import "OWLClassExpression.h"
#import "OWLIndividual.h"

@implementation OWLClassAssertionAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        id objProp = [object individual];
        id selfProp = self.individual;
        BOOL sameIndividual = (objProp == selfProp || [objProp isEqual:selfProp]);
        
        objProp = [object classExpression];
        selfProp = self.classExpression;
        BOOL sameClass = (objProp == selfProp || [objProp isEqual:selfProp]);
        
        equal = sameIndividual && sameClass;
    }
    
    return equal;
}

- (NSUInteger)hash { return [self.individual hash] ^ [self.classExpression hash]; }

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [[NSMutableSet alloc] initWithSet:[self.individual signature]];
    [signature unionSet:[self.classExpression signature]];
    return signature;
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeClassAssertion; }

#pragma mark OWLClassAssertionAxiom

@synthesize individual = _individual;
@synthesize classExpression = _classExpression;

#pragma mark Other public methods

- (instancetype)initWithIndividual:(id<OWLIndividual>)individual classExpression:(id<OWLClassExpression>)classExpression
{
    NSParameterAssert(individual && classExpression);
    
    if ((self = [super init])) {
        _individual = [(id)individual copy];
        _classExpression = [(id)classExpression copy];
    }
    return self;
}

@end
