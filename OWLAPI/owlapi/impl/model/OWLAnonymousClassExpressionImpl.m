//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAnonymousClassExpressionImpl.h"

@implementation OWLAnonymousClassExpressionImpl

#pragma mark OWLClassExpression

- (BOOL)anonymous { return YES; }

- (BOOL)isOWLThing { return NO; }

- (BOOL)isOWLNothing { return NO; }

- (NSSet<id<OWLClassExpression>> *)asConjunctSet { return [NSSet setWithObject:self]; }

- (id<OWLClass>)asOwlClass { return nil; }

@end
