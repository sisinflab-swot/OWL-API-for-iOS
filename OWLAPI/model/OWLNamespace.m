//
//  Created by Ivano Bilenchi on 10/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLNamespace.h"
#import "OWLIRI.h"

#pragma mark Constants

static NSString *const OWLNSPrefix = @"http://www.w3.org/2002/07/owl#";
static NSString *const OWLNSShort = @"owl";

static NSString *const RDFSyntaxNSPrefix = @"http://www.w3.org/1999/02/22-rdf-syntax-ns#";
static NSString *const RDFSyntaxNSShort = @"rdf";

static NSString *const RDFSchemaNSPrefix = @"http://www.w3.org/2000/01/rdf-schema#";
static NSString *const RDFSchemaNSShort = @"rdfs";

OWLNamespace *OWLNamespaceOWL = nil;
OWLNamespace *OWLNamespaceRDFSyntax = nil;
OWLNamespace *OWLNamespaceRDFSchema = nil;


@implementation OWLNamespace

#pragma mark Properties

@synthesize prefix = _prefix;
@synthesize shortName = _shortName;

#pragma mark Class methods

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OWLNamespaceOWL = [[OWLNamespace alloc] initWithPrefix:OWLNSPrefix shortName:OWLNSShort];
        OWLNamespaceRDFSyntax = [[OWLNamespace alloc] initWithPrefix:RDFSyntaxNSPrefix shortName:RDFSyntaxNSShort];
        OWLNamespaceRDFSchema = [[OWLNamespace alloc] initWithPrefix:RDFSchemaNSPrefix shortName:RDFSchemaNSShort];
    });
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([object isKindOfClass:[self class]]) {
        NSString *objStr = [object prefix];
        BOOL samePrefix = (objStr == _prefix || [objStr isEqualToString:_prefix]);
        
        objStr = [object shortName];
        BOOL sameShortName = (objStr == _shortName || [objStr isEqualToString:_shortName]);
        
        equal = (samePrefix && sameShortName);
    }
    
    return equal;
}

- (NSUInteger)hash { return _prefix.hash ^ _shortName.hash; }

#pragma mark NSCopying

// This object is immutable.
- (id)copyWithZone:(__unused NSZone *)zone { return self; }

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

- (OWLIRI *)IRIWithFragment:(NSString *)fragment
{
    OWLIRI *IRI = [[OWLIRI alloc] initWithString:[self stringWithFragment:fragment]];
    NSAssert(IRI, @"Could not create URL.");
    return IRI;
}

@end
