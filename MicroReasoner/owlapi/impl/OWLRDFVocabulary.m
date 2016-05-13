//
//  OWLRDFVocabulary.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 10/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLRDFVocabulary.h"
#import "OWLNamespace.h"

#define LAZY_STATIC_TERM(name, namespace, shortname) \
static OWLRDFTerm *name##Term; \
+ (OWLRDFTerm *)name { \
if (!name##Term) { name##Term = [[OWLRDFTerm alloc] initWithNameSpace:namespace shortName:shortname]; } \
return name##Term; \
}

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

LAZY_STATIC_TERM(RDFType, OWLNamespaceRDFSyntax, @"type");

LAZY_STATIC_TERM(OWLClass, OWLNamespaceOWL, @"Class");
LAZY_STATIC_TERM(OWLObjectProperty, OWLNamespaceOWL, @"ObjectProperty");
LAZY_STATIC_TERM(OWLThing, OWLNamespaceOWL, @"Thing");
LAZY_STATIC_TERM(OWLNothing, OWLNamespaceOWL, @"Nothing");

@end
