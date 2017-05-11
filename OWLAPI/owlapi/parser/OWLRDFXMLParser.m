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
#import "OWLRDFTypeHandlerMap.h"
#import "RDFNode.h"
#import "RDFStatement.h"
#import "raptor.h"

#pragma mark Extension

@interface OWLRDFXMLParser ()
{
    OWLOntologyBuilder *_ontologyBuilder;
    NSMutableArray *_errors;
}
@end

#pragma mark Implementation

@implementation OWLRDFXMLParser

#pragma mark Lifecycle

+ (void)initialize
{
    if (self == [OWLRDFXMLParser class]) {
        predicateHandlerMap = init_predicate_handlers();
        rdfTypeHandlerMap = init_type_handlers();
    }
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

static void statementHandler(void *parser_arg, raptor_statement *triple) {
    @autoreleasepool
    {
        OWLRDFXMLParser *parser = (__bridge OWLRDFXMLParser *)parser_arg;
        NSError *__autoreleasing error = nil;
        
        if (!triple) {
            error = [NSError OWLErrorWithCode:OWLErrorCodeParse
                                  localizedDescription:@"Error while parsing file."];
            goto err;
        }
        
        {
            RDFStatement *statement = [[RDFStatement alloc] initWithRaptorStatement:triple];
            RDFNode *subject = statement.subject;
            RDFNode *predicate = statement.predicate;
            
            if (!predicate.isResource) {
                error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                             localizedDescription:@"Predicates of OWL statements must be resource nodes."
                                         userInfo:@{@"statement": statement}];
                goto err;
            }
            
            if (subject.isLiteral) {
                error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                             localizedDescription:@"Subjects of OWL statements must not be literal nodes."
                                         userInfo:@{@"statement": statement}];
                goto err;
            }
            
            {
                OWLStatementHandler handler = handler_for_predicate(predicateHandlerMap, predicate.cValue);
                if (handler != NULL && !handler(statement, parser->_ontologyBuilder, &error)) {
                    goto err;
                }
            }
        }
        
    err:
        if (error) {
            [parser->_errors addObject:error];
        }
    }
}

- (BOOL)parseOntologyAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    [self initializeDataStructures];
    
    NSError *__autoreleasing localError = nil;
    
    raptor_world *world = NULL;
    raptor_parser* rdf_parser = NULL;
    unsigned char *uri_string = NULL;
    raptor_uri *uri = NULL;
    raptor_uri *base_uri = NULL;
    
    world = raptor_new_world();
    
    if (!world) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeParse
                          localizedDescription:@"Could not create raptor world."
                                      userInfo:@{@"URL": URL}];
        goto err;
    }
    
    raptor_world_open(world);
    rdf_parser = raptor_new_parser(world, "rdfxml");
    
    if (!rdf_parser) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeParse
                          localizedDescription:@"Could not create raptor parser."
                                      userInfo:@{@"URL": URL}];
        goto err;
    }
    
    raptor_parser_set_option(rdf_parser, RAPTOR_OPTION_STRICT, NULL, 1);
    
    uri_string = raptor_uri_filename_to_uri_string([[URL path] UTF8String]);
    
    if (!uri_string) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeParse
                          localizedDescription:@"Invalid URL."
                                      userInfo:@{@"URL": URL}];
        goto err;
    }
    uri = raptor_new_uri(world, uri_string);
    base_uri = raptor_uri_copy(uri);
    
    raptor_parser_set_statement_handler(rdf_parser, (__bridge void *)(self), statementHandler);
    
    if (raptor_parser_parse_file(rdf_parser, uri, base_uri)) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeParse
                          localizedDescription:@"Error(s) while parsing file."
                                      userInfo:@{@"URL": URL}];
        goto err;
    }
    
err:
    raptor_free_uri(base_uri);
    raptor_free_uri(uri);
    raptor_free_memory(uri_string);
    raptor_free_parser(rdf_parser);
    raptor_free_world(world);
    
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

@end
