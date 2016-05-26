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
#import "OWLPredicateHandlerMap.h"
#import "OWLRDFVocabulary.h"
#import "RDFNode.h"
#import "RDFStatement.h"
#import "SMRPreprocessor.h"
#import "redland.h"

#pragma mark Extension

@interface OWLRDFXMLParser ()
{
    OWLOntologyBuilder *_ontologyBuilder;
    NSMutableArray *_errors;
    id<OWLStatementHandlerMap> _predicateHandlerMap;
}
@end

#pragma mark Implementation

@implementation OWLRDFXMLParser

#pragma mark Lifecycle

- (instancetype)init
{
    if ((self = [super init])) {
        _predicateHandlerMap = [[OWLPredicateHandlerMap alloc] init];
    }
    return self;
}

#pragma mark Public methods

- (id<OWLOntology>)parseOntologyFromDocumentAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    NSParameterAssert(URL);
    
    NSError *__autoreleasing localError = nil;
    id<OWLOntology> ontology = nil;
    
    if ([self parseOntologyAtURL:URL error:&localError]) {
        ontology = [_ontologyBuilder build];
    }
    
    if (error) {
        *error = localError;
    }
    
    return localError ? nil : ontology;
}

#pragma mark Private methods

- (void)initializeDataStructures
{
    _errors = [[NSMutableArray alloc] init];
    _ontologyBuilder = [[OWLOntologyBuilder alloc] init];
}

- (BOOL)parseOntologyAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    [self initializeDataStructures];
    
    NSError *__autoreleasing localError = nil;
    NSMutableArray<NSError *> *errors = _errors;
    
    librdf_world *world = librdf_new_world();
    librdf_world_open(world);
    
    librdf_parser *parser = librdf_new_parser(world, "rdfxml", NULL, NULL);
    librdf_stream *stream = NULL;
    
    librdf_uri *uri = librdf_new_uri_from_filename(world, [URL.path UTF8String]);
    
    if (uri == NULL) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeParse
                          localizedDescription:@"librdf_new_uri_from_filename failed."
                                      userInfo:@{@"URL": URL}];
        goto err;
    }
    
    stream = librdf_parser_parse_as_stream(parser, uri, uri);
    
    if (stream == NULL) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeParse
                          localizedDescription:@"Failed to parse file."
                                      userInfo:@{@"URL": URL}];
    }
    
    do {
        @autoreleasepool
        {
            NSError *__autoreleasing statementError = nil;
            librdf_statement *triple = librdf_stream_get_object(stream);
            
            if (!triple) {
                statementError = [NSError OWLErrorWithCode:OWLErrorCodeParse
                                      localizedDescription:@"Error while parsing file."
                                                  userInfo:@{@"URL": URL}];
                [errors addObject:statementError];
                continue;
            }
            
            RDFStatement *statement = [[RDFStatement alloc] initWithLibRdfStatement:triple];
            
            if (![self handleStatement:statement error:&statementError]) {
                [errors addObject:statementError];
            }
        }
    } while (librdf_stream_next(stream) == 0);
    
err:
    librdf_free_uri(uri);
    librdf_free_stream(stream);
    librdf_free_parser(parser);
    librdf_free_world(world);
    
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

- (BOOL)handleStatement:(RDFStatement *)statement error:(NSError *_Nullable __autoreleasing *)error
{
    NSError *__autoreleasing localError = nil;
    
    RDFNode *subject = statement.subject;
    RDFNode *predicate = statement.predicate;
    
    if (!predicate.isResource) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Predicates of OWL statements must be resource nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    if (subject.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subjects of OWL statements must not be literal nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        NSString *signature = predicate.URIStringValue;
        OWLStatementHandler handler = [_predicateHandlerMap handlerForSignature:signature];
        if (handler && !handler(statement, _ontologyBuilder, &localError)) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

@end
