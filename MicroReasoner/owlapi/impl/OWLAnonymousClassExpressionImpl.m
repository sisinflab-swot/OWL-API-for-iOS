//
//  OWLAnonymousClassExpressionImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAnonymousClassExpressionImpl.h"

@implementation OWLAnonymousClassExpressionImpl

#pragma mark OWLClassExpression

- (BOOL)anonymous { return YES; }

- (id<OWLClass>)asOwlClass { return nil; }

@end
