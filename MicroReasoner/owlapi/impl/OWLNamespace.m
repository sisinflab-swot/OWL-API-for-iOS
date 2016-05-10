//
//  OWLNamespace.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 10/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLNamespace.h"

#pragma mark Constants

static NSString *const OWLNSPrefix = @"http://www.w3.org/2002/07/owl#";
static NSString *const OWLNSShort = @"owl";

static NSString *const RDFSchemaNSPrefix = @"http://www.w3.org/2000/01/rdf-schema#";
static NSString *const RDFSchemaNSShort = @"rdfs";

OWLNamespace *OWLNamespaceOWL = nil;
OWLNamespace *OWLNamespaceRDFS = nil;


@implementation OWLNamespace

#pragma mark Properties

@synthesize prefix = _prefix;
@synthesize shortName = _shortName;

#pragma mark Class methods

+ (void)initialize
{
    if (self == [OWLNamespace class]) {
        OWLNamespaceOWL = [[OWLNamespace alloc] initWithPrefix:OWLNSPrefix shortName:OWLNSShort];
        OWLNamespaceRDFS = [[OWLNamespace alloc] initWithPrefix:RDFSchemaNSPrefix shortName:RDFSchemaNSShort];
    }
}

#pragma mark Public instance methods

- (instancetype)initWithPrefix:(NSString *)prefix shortName:(NSString *)shortName
{
    NSParameterAssert(prefix && shortName);
    
    if ((self = [super init])) {
        _prefix = [prefix copy];
        _shortName = [shortName copy];
    }
    return self;
}

- (NSString *)stringWithFragment:(NSString *)fragment
{
    NSParameterAssert(fragment);
    return [self.prefix stringByAppendingString:fragment];
}

- (NSURL *)URLWithFragment:(NSString *)fragment
{
    NSURL *url = [[NSURL alloc] initWithString:[self stringWithFragment:fragment]];
    NSAssert(url, @"Could not create URL.");
    return url;
}

@end
