//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntologyManagerImpl.h"
#import "OWLOntologyID.h"
#import "OWLClassImpl.h"
#import "OWLOntologyImpl.h"
#import "OWLOntologyInternals.h"
#import "OWLRDFXMLParser.h"

@implementation OWLOntologyManagerImpl

#pragma mark Properties

@synthesize dataFactory = _dataFactory;

#pragma mark Lifecycle

- (instancetype)initWithDataFactory:(id<OWLDataFactory>)dataFactory
{
    if ((self = [super init])) {
        _dataFactory = dataFactory;
    }
    
    return self;
}

#pragma mark Public methods

- (id<OWLOntology>)loadOntologyFromDocumentAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    NSParameterAssert(URL);

    NSError *localError = nil;
    OWLRDFXMLParser *parser = [[OWLRDFXMLParser alloc] initWithManager:self];
    
    id<OWLOntology> ontology = [parser parseOntologyFromDocumentAtURL:URL error:&localError];

    if (error) {
        *error = localError;
    }

    return localError ? nil : ontology;
}

@end
