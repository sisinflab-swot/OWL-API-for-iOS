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

- (void)addStatement:(RedlandStatement *)statement
{
    NSParameterAssert(statement);
    [self.internals.allStatements addObject:statement];
}

- (void)addClassDeclarationAxiomForIRI:(NSURL *)IRI
{
    NSParameterAssert(IRI);
    
    OWLClassImpl *class = [[OWLClassImpl alloc] initWithIRI:IRI];
    OWLDeclarationAxiomImpl *axiom = [[OWLDeclarationAxiomImpl alloc] initWithEntity:class];
    
    OWLOntologyInternals *internals = self.internals;
    [internals addAxiom:axiom ofType:OWLAxiomTypeDeclaration];
    [internals addAxiom:axiom forClass:class];
}

- (void)addObjectPropertyDeclarationAxiomForIRI:(NSURL *)IRI
{
    NSParameterAssert(IRI);
    
    OWLObjectPropertyImpl *property = [[OWLObjectPropertyImpl alloc] initWithIRI:IRI];
    OWLDeclarationAxiomImpl *axiom = [[OWLDeclarationAxiomImpl alloc] initWithEntity:property];
    
    OWLOntologyInternals *internals = self.internals;
    [internals addAxiom:axiom ofType:OWLAxiomTypeDeclaration];
    [internals addAxiom:axiom forObjectProperty:property];
}

@end
