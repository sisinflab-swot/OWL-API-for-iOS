//
//  OWLOntologyInternalsBuilder.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 13/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntologyBuilder.h"
#import "OWLClassImpl.h"
#import "OWLDeclarationAxiomImpl.h"
#import "OWLNamedIndividualImpl.h"
#import "OWLObjectPropertyImpl.h"
#import "OWLOntologyID.h"
#import "OWLOntologyImpl.h"
#import "OWLOntologyInternals.h"
#import "SMRPreprocessor.h"

@interface OWLOntologyBuilder ()

@property (nonatomic, strong, readonly) OWLOntologyInternals *internals;

@end


@implementation OWLOntologyBuilder

SYNTHESIZE_LAZY_INIT(OWLOntologyInternals, internals);

@synthesize ontologyIRI = _ontologyIRI;
@synthesize versionIRI = _versionIRI;

- (id<OWLOntology>)buildOWLOntology
{
    OWLOntologyID *ontologyID = [[OWLOntologyID alloc] initWithOntologyIRI:self.ontologyIRI versionIRI:self.versionIRI];
    return [[OWLOntologyImpl alloc] initWithID:ontologyID internals:self.internals];
}

- (void)addDeclarationOfType:(OWLEntityType)type withIRI:(NSURL *)IRI
{
    NSParameterAssert(IRI);
    
    OWLOntologyInternals *internals = self.internals;
    id<OWLAxiom> axiom = nil;
    
    switch (type) {
        case OWLEntityTypeClass:
        {
            OWLClassImpl *class = [[OWLClassImpl alloc] initWithIRI:IRI];
            axiom = [[OWLDeclarationAxiomImpl alloc] initWithEntity:class];
            [internals addAxiom:axiom forClass:class];
            break;
        }
        case OWLEntityTypeNamedIndividual:
        {
            OWLNamedIndividualImpl *individual = [[OWLNamedIndividualImpl alloc] initWithIRI:IRI];
            axiom = [[OWLDeclarationAxiomImpl alloc] initWithEntity:individual];
            [internals addAxiom:axiom forNamedIndividual:individual];
        }
        case OWLEntityTypeObjectProperty:
        {
            OWLObjectPropertyImpl *property = [[OWLObjectPropertyImpl alloc] initWithIRI:IRI];
            axiom = [[OWLDeclarationAxiomImpl alloc] initWithEntity:property];
            [internals addAxiom:axiom forObjectProperty:property];
            break;
        }
        default:
            break;
    }
    
    if (axiom) {
        [internals addAxiom:axiom ofType:OWLAxiomTypeDeclaration];
    }
}

@end
