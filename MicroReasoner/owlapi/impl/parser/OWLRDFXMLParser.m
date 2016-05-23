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

/// The ontology builder.
@property (nonatomic, strong) OWLOntologyBuilder *ontologyBuilder;

/// Errors accumulated during the parsing process.
@property (nonatomic, strong) NSMutableArray<NSError *> *errors;

/// Maps predicates to their respective handlers.
@property (nonatomic, strong, readonly) id<OWLStatementHandlerMap> predicateHandlerMap;

@end

#pragma mark Implementation

@implementation OWLRDFXMLParser

#pragma mark Properties

SYNTHESIZE_LAZY_INIT(NSMutableArray, errors);
SYNTHESIZE_LAZY_INIT(OWLOntologyBuilder, ontologyBuilder);
SYNTHESIZE_LAZY_INIT(OWLPredicateHandlerMap, predicateHandlerMap);

#pragma mark Public methods

- (id<OWLOntology>)parseOntologyFromDocumentAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    NSParameterAssert(URL);
    
    NSError *__autoreleasing localError = nil;
    id<OWLOntology> ontology = nil;
    
    if ([self parseOntologyAtURL:URL error:&localError]) {
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

- (BOOL)parseOntologyAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    [self initializeDataStructures];
    
    NSError *__autoreleasing localError = nil;
    NSMutableArray<NSError *> *errors = self.errors;
    
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
    
    {
        stream = librdf_parser_parse_as_stream(parser, uri, uri);
        
        if (stream == NULL) {
            localError = [NSError OWLErrorWithCode:OWLErrorCodeParse
                              localizedDescription:@"Failed to parse file."
                                          userInfo:@{@"URL": URL}];
        }
        
        BOOL hasNext = NO;
        
        do {
            @autoreleasepool {
                librdf_statement *statement = librdf_stream_get_object(stream);
                RDFStatement *stmt = [[RDFStatement alloc] initWithWrappedObject:statement owner:NO];
                
                NSError *__autoreleasing statementError = nil;
                if (![self handleStatement:stmt error:&statementError]) {
                    [errors addObject:statementError];
                }
                
                hasNext = (librdf_stream_next(stream) == 0);
            }
        } while (hasNext);
    }
    
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
    OWLRDFXMLParser *__weak weakSelf = self;
    
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
        OWLStatementHandler handler = [self.predicateHandlerMap handlerForSignature:signature];
        if (handler && !handler(statement, weakSelf.ontologyBuilder, &localError)) {
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
