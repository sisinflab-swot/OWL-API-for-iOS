//
//  OWLIndividualImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLIndividual.h"

/// Abstract class that informally implements part of the OWLIndividual protocol.
@interface OWLIndividualImpl : OWLObjectImpl

#pragma mark OWLIndividual

- (NSSet<id<OWLClassExpression>> *)typesInOntology:(id<OWLOntology>)ontology;

@end
