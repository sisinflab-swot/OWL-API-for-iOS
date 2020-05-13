//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OWLAPI/OWLAPI.h"

static id<OWLOntology> ontology = nil;


@interface OWLOntologyTests : XCTestCase @end

@implementation OWLOntologyTests

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadOntology();
        NSLog(@"%@", ontology.ontologyID);
    });
}

static void loadOntology() {
    if (!ontology) {
        loadOntologyNoCache();
    }
}

static void loadOntologyNoCache() {
    Class testsClass = [OWLOntologyTests class];
    NSURL *ontoURL = [[NSBundle bundleForClass:testsClass] URLForResource:@"building" withExtension:@"owl"];
    ontology = [[OWLManager createOWLOntologyManager] loadOntologyFromDocumentAtURL:ontoURL error:NULL];
}

- (void)testLoadOntology {
    loadOntologyNoCache();
    XCTAssertNotNil(ontology);
}

- (void)testAllAxioms {
    NSMutableSet *axioms = [[NSMutableSet alloc] init];
    [ontology enumerateAxiomsWithHandler:^(id<OWLAxiom> axiom) {
        [axioms addObject:axiom];
    }];
    NSLog(@"Axioms (%lu):\n------------------\n%@", (unsigned long)axioms.count, axioms);
}

- (void)testAxiomsForType {
    NSMutableSet *axioms = [[NSMutableSet alloc] init];

    [ontology enumerateAxiomsOfTypes:OWLAxiomTypeDeclaration withHandler:^(id<OWLAxiom> axiom) {
        [axioms addObject:axiom];
    }];

    NSLog(@"Declaration axioms (%lu):\n------------------\n%@", (unsigned long)axioms.count, axioms);
    
    [axioms removeAllObjects];
    [ontology enumerateAxiomsOfTypes:OWLAxiomTypeClassAssertion withHandler:^(id<OWLAxiom> axiom) {
        [axioms addObject:axiom];
    }];

    NSLog(@"Class assertion axioms (%lu):\n----------------------\n%@", (unsigned long)axioms.count, axioms);
}

- (void)testClassesInSignature {
    NSMutableSet *classes = [[NSMutableSet alloc] init];

    [ontology enumerateClassesInSignatureWithHandler:^(id<OWLClass> owlClass) {
        [classes addObject:owlClass];
    }];

    NSLog(@"Classes (%lu):\n--------\n%@", (unsigned long)classes.count, classes);
}

- (void)testDisjointClassAxiomsForClass {
    NSMutableArray *axioms = [[NSMutableArray alloc] init];

    [ontology enumerateClassesInSignatureWithHandler:^(id<OWLClass> owlClass) {
        [ontology enumerateAxiomsReferencingClass:owlClass
                                          ofTypes:OWLAxiomTypeDisjointClasses
                                      withHandler:^(id<OWLAxiom> axiom) {
            [axioms addObject:axiom];
        }];
    }];

    NSLog(@"DisjointClass axioms (%lu):\n--------------------\n%@", (unsigned long)axioms.count, axioms);
}

- (void)testEquivalentClassAxiomsForClass {
    NSMutableArray *axioms = [[NSMutableArray alloc] init];

    [ontology enumerateClassesInSignatureWithHandler:^(id<OWLClass> owlClass) {
        [ontology enumerateAxiomsReferencingClass:owlClass
                                          ofTypes:OWLAxiomTypeEquivalentClasses
                                      withHandler:^(id<OWLAxiom> axiom) {
            [axioms addObject:axiom];
        }];
    }];

    NSLog(@"EquivalentClass axioms (%lu):\n----------------------\n%@", (unsigned long)axioms.count, axioms);
}

- (void)testNamedIndividualsInSignature {
    NSMutableSet *individuals = [[NSMutableSet alloc] init];

    [ontology enumerateNamedIndividualsInSignatureWithHandler:^(id<OWLNamedIndividual> ind) {
        [individuals addObject:ind];
    }];

    NSLog(@"Individuals (%lu):\n-----------\n%@", (unsigned long)individuals.count, individuals);
}

- (void)testObjectPropertiesInSignature {
    NSMutableSet *properties = [[NSMutableSet alloc] init];

    [ontology enumerateObjectPropertiesInSignatureWithHandler:^(id<OWLObjectProperty> prop) {
        [properties addObject:prop];
    }];

    NSLog(@"Object properties (%lu):\n-----------------\n%@", (unsigned long)properties.count, properties);
}

- (void)testSubClassAxiomsForSubClass {
    NSMutableArray *axioms = [[NSMutableArray alloc] init];

    [ontology enumerateClassesInSignatureWithHandler:^(id<OWLClass> owlClass) {
        [ontology enumerateAxiomsReferencingClass:owlClass
                                          ofTypes:OWLAxiomTypeSubClassOf
                                      withHandler:^(id<OWLAxiom> axiom) {
            id<OWLSubClassOfAxiom> subAxiom = (id<OWLSubClassOfAxiom>)axiom;
            if ([subAxiom.subClass isEqual:owlClass]) {
                [axioms addObject:axiom];
            }
        }];
    }];

    NSLog(@"SubClassOf axioms (%lu):\n-----------------\n%@", (unsigned long)axioms.count, axioms);
}

@end
