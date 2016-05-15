//
//  OWLObjectPropertyExpressionImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 08/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyExpressionImpl.h"

@implementation OWLObjectPropertyExpressionImpl

#pragma mark OWLPropertyExpression

- (BOOL)isDataPropertyExpression { return NO; }

- (BOOL)isObjectPropertyExpression { return YES; }

@end
