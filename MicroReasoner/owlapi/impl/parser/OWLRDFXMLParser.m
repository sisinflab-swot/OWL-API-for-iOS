//
//  OWLRDFXMLParser.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLRDFXMLParser.h"
#import "OWLError.h"
#import "OWLNamespace.h"
#import "OWLOntologyBuilder.h"
#import "OWLRDFVocabulary.h"
#import "OWLStatementHandler.h"
#import "SMRPreprocessor.h"
#import <Redland-ObjC.h>

#pragma mark Extension

@interface OWLRDFXMLParser ()

/// The ontology builder.
@property (nonatomic, strong) OWLOntologyBuilder *ontologyBuilder;

/// Errors accumulated during the parsing process.
@property (nonatomic, strong) NSMutableArray<NSError *> *errors;

/// Maps predicates to their respective handlers.
@property (nonatomic, strong, readonly)
NSDictionary<NSString *, OWLStatementHandler> *predicateHandlerMap;

@end

#pragma mark Implementation

@implementation OWLRDFXMLParser

#pragma mark Properties

SYNTHESIZE_LAZY_INIT(NSMutableArray, errors);
SYNTHESIZE_LAZY_INIT(OWLOntologyBuilder, ontologyBuilder);

SYNTHESIZE_LAZY(NSDictionary, predicateHandlerMap)
{
    NSMutableDictionary<NSString *, OWLStatementHandler> *map = [[NSMutableDictionary alloc] init];
    
    map[[OWLRDFVocabulary RDFType].stringValue] = [pRDFTypeHandler copy];
    map[[OWLRDFVocabulary OWLOnProperty].stringValue] = [pOnPropertyHandler copy];
    map[[OWLRDFVocabulary OWLSomeValuesFrom].stringValue] = [pSomeValuesFromHandler copy];
    
    return map;
}

#pragma mark Public methods

- (id<OWLOntology>)parseOntologyFromDocumentAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    NSParameterAssert(URL);
    
    NSError *__autoreleasing localError = nil;
    id<OWLOntology> ontology = nil;
    
    if ([self _parseOntologyAtURL:URL error:&localError]) {
        ontology = [self.ontologyBuilder build];
    }
    
    if (error) {
        *error = localError;
    }
    
    return localError ? nil : ontology;
}

#pragma mark Private methods

- (void)initializeDataStructures
{
    self.errors = nil;
    self.ontologyBuilder = nil;
}

- (BOOL)_parseOntologyAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    [self initializeDataStructures];
    
    // Return vars
    NSError *__autoreleasing localError = nil;
    
    // Work vars
    RedlandParser *parser = [[RedlandParser alloc] initWithName:RedlandRDFXMLParserName];
    RedlandURI *baseURI = [RedlandURI URIWithString:OWLNamespaceRDFSyntax.prefix];
    RedlandStream *stream = nil;
    
    // Load file into string
    NSString *ontoString = [[NSString alloc] initWithContentsOfURL:URL
                                                      usedEncoding:NULL
                                                             error:&localError];
    if (!ontoString) {
        goto err;
    }
    
    // Parse string
    stream = [parser parseString:ontoString asStreamWithBaseURI:baseURI error:&localError];
    
    if (!stream) {
        goto err;
    }
    
    for (RedlandStatement *statement in stream.statementEnumerator) {
        NSError *__autoreleasing statementError = nil;
        
        if (![self _handleStatement:statement error:&statementError] && statementError) {
            [self.errors addObject:statementError];
        }
    }
    
err:
    if (error) {
        if (!localError && self.errors.count) {
            localError = [NSError OWLErrorWithCode:OWLErrorCodeCumulative
                                 localizedDescription:@"Error(s) during the ontology parsing process."
                                             userInfo:@{@"errors": self.errors}];
        }
        *error = localError;
    }
    
    return !localError;
}

- (BOOL)_handleStatement:(RedlandStatement *)statement error:(NSError *_Nullable __autoreleasing *)error
{
    NSError *__autoreleasing localError = nil;
    OWLRDFXMLParser *__weak weakSelf = self;
    
    RedlandNode *predicate = statement.predicate;
    
    if (predicate.isResource) {
        OWLStatementHandler handler = self.predicateHandlerMap[predicate.URIStringValue];
        if (handler && !handler(statement, weakSelf.ontologyBuilder, &localError)) {
            goto err;
        }
    } else {
        // Error: OWL predicates must be resource nodes
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"OWL statements' predicates must be resource nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

@end
