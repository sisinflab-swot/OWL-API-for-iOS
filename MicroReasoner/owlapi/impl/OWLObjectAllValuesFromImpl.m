//
//  OWLObjectAllValuesFromImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectAllValuesFromImpl.h"
#import "OWLPropertyExpression.h"

@implementation OWLObjectAllValuesFromImpl

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType { return OWLClassExpTypeDataAllValuesFrom; }

@end
