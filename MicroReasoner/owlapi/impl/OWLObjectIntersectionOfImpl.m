//
//  OWLObjectIntersectionOfImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectIntersectionOfImpl.h"

@implementation OWLObjectIntersectionOfImpl

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType { return OWLClassExpTypeObjectIntersectionOf; }

- (NSSet<id<OWLClassExpression>> *)asConjunctSet
{
    NSMutableSet *conjunctSet = [[NSMutableSet alloc] init];
    
    for (id<OWLClassExpression> operand in self.operands) {
        [conjunctSet unionSet:[operand asConjunctSet]];
    }
    
    return conjunctSet;
}

@end
