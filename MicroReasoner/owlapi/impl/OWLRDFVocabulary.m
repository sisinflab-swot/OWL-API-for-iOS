//
//  OWLRDFVocabulary.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 10/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLRDFVocabulary.h"
#import "OWLNamespace.h"

#define LAZY_TERM(var, ns, sn) { \
if (!var) { \
    var = [[OWLRDFTerm alloc] initWithNameSpace:ns shortName:sn]; \
} \
return var; \
}

#pragma mark Constants

static NSString *const RDFTermStringType = @"type";

static NSString *const OWLTermStringClass = @"Class";
static NSString *const OWLTermStringThing = @"Thing";
static NSString *const OWLTermStringNothing = @"Nothing";

#pragma mark Static globals

static OWLRDFTerm *RDFTermType = nil;

static OWLRDFTerm *OWLTermClass = nil;
static OWLRDFTerm *OWLTermThing = nil;
static OWLRDFTerm *OWLTermNothing = nil;

@implementation OWLRDFTerm

#pragma mark Properties

// IRI
@synthesize IRI = _IRI;

- (NSURL *)IRI
{
    if (!_IRI) {
        _IRI = [self.nameSpace URLWithFragment:self.shortName];
    }
    return _IRI;
}

// Others
@synthesize nameSpace = _nameSpace;
@synthesize shortName = _shortName;

#pragma mark Public methods

- (instancetype)initWithNameSpace:(NSString *)nameSpace shortName:(NSString *)shortName
{
    NSParameterAssert(nameSpace && shortName);
    
    if ((self = [super init])) {
        _nameSpace = [nameSpace copy];
        _shortName = [shortName copy];
    }
    return self;
}

- (NSString *)stringValue { return [self.nameSpace.prefix stringByAppendingString:self.shortName]; }

@end


@implementation OWLRDFVocabulary

+ (OWLRDFTerm *)RDFType LAZY_TERM(RDFTermType, OWLNamespaceRDFSyntax, RDFTermStringType)

+ (OWLRDFTerm *)OWLClass LAZY_TERM(OWLTermClass, OWLNamespaceOWL, OWLTermStringClass)
+ (OWLRDFTerm *)OWLThing LAZY_TERM(OWLTermThing, OWLNamespaceOWL, OWLTermStringThing)
+ (OWLRDFTerm *)OWLNothing LAZY_TERM(OWLTermNothing, OWLNamespaceOWL, OWLTermStringNothing)

@end
