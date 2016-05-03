//
//  MicroReasonerTests.m
//  MicroReasonerTests
//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OWLOntology.h"

static OWLOntology *ontology = nil;


@interface MicroReasonerTests : XCTestCase

@end


@implementation MicroReasonerTests

+ (void)initialize
{
    if (self == [MicroReasonerTests class]) {
        NSURL *ontoURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"building" withExtension:@"owl"];
        ontology = [[OWLOntology alloc] initWithContentsOfURL:ontoURL];
    }
}

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testStatements
{
    NSArray *statements = [ontology allStatements];
    NSLog(@"Statements (%lu):\n-----------\n%@", statements.count, statements);
    XCTAssertTrue(statements.count > 0);
}

- (void)testClasses
{
    NSArray *classes = [ontology.classesInSignature allValues];
    NSLog(@"Classes (%lu):\n--------\n%@", classes.count, classes);
    XCTAssertTrue(classes.count > 0);
}

@end
