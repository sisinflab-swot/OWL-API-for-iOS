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
#import "SMRPreprocessor.h"
#import <Redland-ObjC.h>

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
    
    RedlandParser *parser = [[RedlandParser alloc] initWithName:RedlandRDFXMLParserName];
    RedlandURI *baseURI = [RedlandURI URIWithString:OWLNamespaceRDFSyntax.prefix];
    
    RedlandStream *stream = [parser parseFileAtPath:URL.path asStreamWithBaseURI:baseURI error:&localError];
    
    if (!stream) {
        goto err;
    }
    
    for (RedlandStatement *statement in stream.statementEnumerator) {
        NSError *__autoreleasing statementError = nil;
        @autoreleasepool {
            if (![self handleStatement:statement error:&statementError] && statementError) {
                [self.errors addObject:statementError];
            }
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

- (BOOL)handleStatement:(RedlandStatement *)statement error:(NSError *_Nullable __autoreleasing *)error
{
    NSError *__autoreleasing localError = nil;
    OWLRDFXMLParser *__weak weakSelf = self;
    
    RedlandNode *subject = statement.subject;
    RedlandNode *predicate = statement.predicate;
    
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
        OWLStatementHandler handler = [self.predicateHandlerMap handlerForSignature:predicate.URIStringValue];
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
