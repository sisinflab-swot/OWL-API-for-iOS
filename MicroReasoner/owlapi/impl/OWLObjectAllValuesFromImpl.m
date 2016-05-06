//
//  OWLObjectAllValuesFromImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectAllValuesFromImpl.h"
#import "OWLPropertyExpression.h"
#import "OWLPropertyRange.h"

@implementation OWLObjectAllValuesFromImpl

#pragma mark OWLObject

- (NSSet<id<OWLEntity>> *)signature
{
    NSMutableSet *signature = [[NSMutableSet alloc] initWithSet:[self.property signature]];
    [signature unionSet:[self.filler signature]];
    return signature;
}

#pragma mark OWLRestriction

- (BOOL)isObjectRestriction { return YES; }

- (BOOL)isDataRestriction { return NO; }

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType { return OWLClassExpTypeDataAllValuesFrom; }

@end
