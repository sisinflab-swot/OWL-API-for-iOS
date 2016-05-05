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


@interface MicroReasonerTests : XCTestCase

@end


@implementation MicroReasonerTests

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

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testLoadOntology
{
    [self measureBlock:^{
        loadOntologyNoCache();
    }];
    XCTAssertNotNil(ontology);
}

- (void)testAllStatements
{
    loadOntology();
    
    NSArray *statements = [(NSObject *)ontology valueForKeyPath:@"internals.allStatements"];
    NSLog(@"Statements (%lu):\n-----------\n%@", (unsigned long)statements.count, statements);
    XCTAssertTrue(statements.count > 0);
}

- (void)testGetClassesInSignature
{
    loadOntology();
    
    NSArray *classes = [[ontology getClassesInSignature] allObjects];
    NSLog(@"Classes (%lu):\n--------\n%@", (unsigned long)classes.count, classes);
    XCTAssertTrue(classes.count > 0);
}

@end
