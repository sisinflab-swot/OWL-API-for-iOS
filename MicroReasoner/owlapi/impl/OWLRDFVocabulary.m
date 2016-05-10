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

static NSString *const OWLTermStringThing = @"Thing";
static NSString *const OWLTermStringNothing = @"Nothing";

#pragma mark Static globals

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

@end


@implementation OWLRDFVocabulary

+ (OWLRDFTerm *)thing LAZY_TERM(OWLTermThing, OWLNamespaceOWL, OWLTermStringThing)
+ (OWLRDFTerm *)nothing LAZY_TERM(OWLTermNothing, OWLNamespaceOWL, OWLTermStringNothing)

@end
