//
//  Created by Ivano Bilenchi on 27/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLTransitiveObjectPropertyAxiomImpl.h"

@implementation OWLTransitiveObjectPropertyAxiomImpl

#pragma mark NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"TransitiveObjectProperty(%@)", self.property];
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeTransitiveObjectProperty; }

@end
