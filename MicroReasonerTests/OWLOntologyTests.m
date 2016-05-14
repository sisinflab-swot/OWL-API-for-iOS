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
    [self measureBlock:^{
        loadOntologyNoCache();
    }];
    XCTAssertNotNil(ontology);
}

- (void)testClassesInSignature
{
    NSSet *classes = [ontology classesInSignature];
    NSLog(@"Classes (%lu):\n--------\n%@", (unsigned long)classes.count, classes);
    XCTAssertTrue(classes.count > 0);
}

- (void)testObjectPropertiesInSignature
{
    NSSet *properties = [ontology objectPropertiesInSignature];
    NSLog(@"Object properties (%lu):\n-----------------\n%@", (unsigned long)properties.count, properties);
    XCTAssertTrue(properties.count > 0);
}

@end
