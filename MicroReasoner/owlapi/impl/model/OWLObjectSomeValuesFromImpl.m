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

#pragma mark NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"ObjectSomeValuesFrom(%@ %@)", self.property, self.filler];
}

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType { return OWLClassExpTypeObjectSomeValuesFrom; }

@end
