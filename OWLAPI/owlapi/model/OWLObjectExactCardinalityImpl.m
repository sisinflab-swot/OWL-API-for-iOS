//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectExactCardinalityImpl.h"

@implementation OWLObjectExactCardinalityImpl

#pragma mark NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"ObjectExactCardinality(%lu %@ %@)", (unsigned long)self.cardinality, self.property, self.filler];
}

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType { return OWLClassExpTypeObjectExactCardinality; }

@end
