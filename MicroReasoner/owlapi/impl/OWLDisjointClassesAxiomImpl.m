//
//  OWLDisjointClassAxiomImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 09/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLDisjointClassesAxiomImpl.h"

@implementation OWLDisjointClassesAxiomImpl

#pragma mark OWLAxiom

- (OWLAxiomType)axiomType { return OWLAxiomTypeDisjointClasses; }

@end
