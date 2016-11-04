//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLIndividualImpl.h"
#import "OWLClassAssertionAxiom.h"
#import "OWLOntology.h"

@implementation OWLIndividualImpl

#pragma mark OWLIndividual

- (NSSet<id<OWLClassExpression>> *)typesInOntology:(id<OWLOntology>)ontology
{
    NSMutableSet *types = [[NSMutableSet alloc] init];
    NSSet *axioms = [ontology classAssertionAxiomsForIndividual:(id<OWLIndividual>)self];
    
    for (id<OWLClassAssertionAxiom> axiom in axioms) {
        [types addObject:axiom.classExpression];
    }
    
    return types;
}

@end
