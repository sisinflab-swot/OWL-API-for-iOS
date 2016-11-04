//
//  Created by Ivano Bilenchi on 09/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLEquivalentClassesAxiomImpl.h"

@implementation OWLEquivalentClassesAxiomImpl

#pragma mark NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"EquivalentClasses(%@)", [[self.classExpressions allObjects] componentsJoinedByString:@" "]];
}

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeEquivalentClasses; }

@end
