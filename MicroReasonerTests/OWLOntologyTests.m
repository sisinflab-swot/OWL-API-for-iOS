//
//  MicroReasonerTests.m
//  MicroReasonerTests
//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Microreasoner/MicroReasoner.h"

static id<OWLOntology> ontology = nil;


@interface MicroReasonerTests : XCTestCase @end

@implementation MicroReasonerTests

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadOntology();
    });
}

static void loadOntology() {
    if (!ontology) {
        loadOntologyNoCache();
    }
}

static void loadOntologyNoCache() {
    Class testsClass = [MicroReasonerTests class];
    NSURL *ontoURL = [[NSBundle bundleForClass:testsClass] URLForResource:@"building" withExtension:@"owl"];
    ontology = [[OWLManager createOWLOntologyManager] loadOntologyFromDocumentAtURL:ontoURL error:NULL];
}

- (void)testLoadOntology
{
    loadOntologyNoCache();
    XCTAssertNotNil(ontology);
}

- (void)testAxiomsForType
{
    NSSet *decl = [ontology axiomsForType:OWLAxiomTypeDeclaration];
    NSLog(@"Declaration axioms (%lu):\n------------------\n%@", (unsigned long)decl.count, decl);
    
    decl = [ontology axiomsForType:OWLAxiomTypeClassAssertion];
    NSLog(@"Class assertion axioms (%lu):\n----------------------\n%@", (unsigned long)decl.count, decl);
    
    XCTAssertNotNil(decl);
}

- (void)testClassesInSignature
{
    NSSet *classes = [ontology classesInSignature];
    NSLog(@"Classes (%lu):\n--------\n%@", (unsigned long)classes.count, classes);
    XCTAssertNotNil(classes);
}

- (void)testNamedIndividualsInSignature
{
    NSSet *individuals = [ontology namedIndividualsInSignature];
    NSLog(@"Individuals (%lu):\n-----------\n%@", (unsigned long)individuals.count, individuals);
    XCTAssertNotNil(individuals);
}

- (void)testObjectPropertiesInSignature
{
    NSSet *properties = [ontology objectPropertiesInSignature];
    NSLog(@"Object properties (%lu):\n-----------------\n%@", (unsigned long)properties.count, properties);
    XCTAssertNotNil(properties);
}

- (void)testSubClassAxiomsForSubClass
{
    NSMutableArray *subClassAxioms = [[NSMutableArray alloc] init];
    NSSet *classesInSignature = [ontology classesInSignature];
    XCTAssertNotNil(classesInSignature);
    
    for (id<OWLClass> cls in classesInSignature) {
        NSSet *axiomsForClass = [ontology subClassAxiomsForSubClass:cls];
        XCTAssertNotNil(axiomsForClass);
        [subClassAxioms addObjectsFromArray:[axiomsForClass allObjects]];
    }
    
    NSLog(@"SubClassOf axioms (%lu):\n-----------------\n%@", (unsigned long)subClassAxioms.count, subClassAxioms);
}

- (void)testDisjointClassAxiomsForClass
{
    NSMutableArray *disjointClassAxioms = [[NSMutableArray alloc] init];
    NSSet *classesInSignature = [ontology classesInSignature];
    XCTAssertNotNil(classesInSignature);
    
    for (id<OWLClass> cls in classesInSignature) {
        NSSet *axiomsForClass = [ontology disjointClassesAxiomsForClass:cls];
        XCTAssertNotNil(axiomsForClass);
        [disjointClassAxioms addObjectsFromArray:[axiomsForClass allObjects]];
    }
    
    NSLog(@"DisjointClass axioms (%lu):\n--------------------\n%@", (unsigned long)disjointClassAxioms.count, disjointClassAxioms);
}

- (void)testEquivalentClassAxiomsForClass
{
    NSMutableArray *equivalentClassAxioms = [[NSMutableArray alloc] init];
    NSSet *classesInSignature = [ontology classesInSignature];
    XCTAssertNotNil(classesInSignature);
    
    for (id<OWLClass> cls in classesInSignature) {
        NSSet *axiomsForClass = [ontology equivalentClassesAxiomsForClass:cls];
        XCTAssertNotNil(axiomsForClass);
        [equivalentClassAxioms addObjectsFromArray:[axiomsForClass allObjects]];
    }
    
    NSLog(@"EquivalentClass axioms (%lu):\n----------------------\n%@", (unsigned long)equivalentClassAxioms.count, equivalentClassAxioms);
}

@end
