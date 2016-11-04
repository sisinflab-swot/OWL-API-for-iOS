//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectMinCardinalityImpl.h"

@implementation OWLObjectMinCardinalityImpl

#pragma mark NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"ObjectMinCardinality(%lu %@ %@)", (unsigned long)self.cardinality, self.property, self.filler];
}

#pragma mark OWLClassExpression

- (OWLClassExpressionType)classExpressionType { return OWLClassExpTypeObjectMinCardinality; }

@end
