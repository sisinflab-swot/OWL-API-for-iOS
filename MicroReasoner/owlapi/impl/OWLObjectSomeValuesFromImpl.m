//
//  OWLObjectSomeValuesFromImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectSomeValuesFromImpl.h"
#import "OWLPropertyExpression.h"

@implementation OWLObjectSomeValuesFromImpl

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [[NSMutableSet alloc] initWithSet:[self.property signature]];
    [signature unionSet:[self.filler signature]];
    return signature;
}

#pragma mark OWLRestriction

- (BOOL)isObjectRestriction { return YES; }

- (BOOL)isDataRestriction { return YES; }

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType { return OWLClassExpTypeObjectSomeValuesFrom; }

@end
