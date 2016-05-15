//
//  OWLRDFXMLParser.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLRDFXMLParser.h"
#import "OWLEntityType.h"
#import "OWLError.h"
#import "OWLNamespace.h"
#import "OWLOntologyBuilder.h"
#import "OWLRDFVocabulary.h"
#import "SMRPreprocessor.h"
#import <Redland-ObjC.h>

#pragma mark Definitions

typedef BOOL (^OWLStatementHandler)(RedlandStatement *_Nonnull, OWLRDFXMLParser *_Nonnull, NSError *_Nullable __autoreleasing *);

#pragma mark Extension

@interface OWLRDFXMLParser ()

/// Maps predicates to their respective handlers.
@property (nonatomic, strong, readonly) NSDictionary<NSString *, OWLStatementHandler> *predicateHandlerMap;

/// Maps objects to their respective handlers.
@property (nonatomic, strong, readonly) NSDictionary<NSString *, OWLStatementHandler> *objectHandlerMap;

/// IRI -> NSNumber enclosing OWLEntityType.
@property (nonatomic, strong, readonly) NSMutableDictionary<NSURL*,NSNumber*> *declarations;

/// Errors accumulated during the parsing process.
@property (nonatomic, strong, readonly) NSMutableArray<NSError *> *errors;

@end

#pragma mark Statement handlers

/// rdf:type predicate handler
OWLStatementHandler pRDFTypeHandler = ^BOOL(RedlandStatement *statement, OWLRDFXMLParser *parser, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *object = statement.object;
    
    if (object.isResource) {
        // Declaration of named entity
        // Class expression declaration
        // Individual named class assertion
        NSString *objectURIString = object.URIStringValue;
        OWLStatementHandler handler = parser.objectHandlerMap[objectURIString];
        
        if (handler) {
            // Declaration of named entity
            // Class expression declaration
            if (!handler(statement, parser, &localError)) {
                goto err;
            }
        } else {
            // Individual named class assertion
            // TODO: implement
        }
    } else {
        // Individual unnamed class assertion
        // TODO: implement
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

/// Class declaration handler
OWLStatementHandler oClassHandler = ^BOOL(RedlandStatement *statement, OWLRDFXMLParser *parser, __unused NSError *__autoreleasing *error)
{
    RedlandNode *subject = statement.subject;
    
    if (subject.isResource) {
        // Class declaration
        parser.declarations[subject.URLValue] = [NSNumber numberWithInteger:OWLEntityTypeClass];
    } else {
        // Class expression declaration
        // TODO: implement
    }
    
    return YES;
};

/// Object property declaration handler
OWLStatementHandler oObjectPropertyHandler = ^BOOL(RedlandStatement *statement, OWLRDFXMLParser *parser, NSError *__autoreleasing *error)
{
    NSError *localError = nil;
    RedlandNode *subject = statement.subject;
    
    if (subject.isResource) {
        // Object property declaration
        parser.declarations[subject.URLValue] = [NSNumber numberWithInteger:OWLEntityTypeObjectProperty];
    } else {
        // Error: object property declaration statements must have resource-type subject nodes
        localError = [NSError OWLErrorWithCode:OWLErrorCodeParse
                          localizedDescription:@"Object property declaration statements must have resource-type subject nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

#pragma mark Implementation

@implementation OWLRDFXMLParser

#pragma mark Properties

SYNTHESIZE_LAZY_INIT(NSMutableDictionary, declarations);
SYNTHESIZE_LAZY_INIT(NSMutableArray, errors);

#pragma mark Statement handler maps

#define handlerNotImplemented(name) \
key = [OWLRDFVocabulary name].stringValue; \
map[key] = [^BOOL( \
__unused RedlandStatement *s, \
__unused OWLRDFXMLParser *p, \
__unused NSError *__autoreleasing *e) \
{ return YES; } copy]

SYNTHESIZE_LAZY(NSDictionary, objectHandlerMap)
{
    NSMutableDictionary<NSString *, OWLStatementHandler> *map = [[NSMutableDictionary alloc] init];
    NSString *key = nil;
    
    // Class declaration handler
    key = [OWLRDFVocabulary OWLClass].stringValue;
    map[key] = [oClassHandler copy];
    
    // Object property declaration handler
    key = [OWLRDFVocabulary OWLObjectProperty].stringValue;
    map[key] = [oObjectPropertyHandler copy];
    
    // Not implemented handlers
    handlerNotImplemented(OWLAllDifferent);
    handlerNotImplemented(OWLAllDisjointClasses);
    handlerNotImplemented(OWLAllDisjointProperties);
    handlerNotImplemented(OWLAnnotation);
    handlerNotImplemented(OWLAnnotationProperty);
    handlerNotImplemented(OWLAsymmetricProperty);
    handlerNotImplemented(OWLAxiom);
    handlerNotImplemented(OWLDatatypeProperty);
    handlerNotImplemented(OWLDeprecatedClass);
    handlerNotImplemented(OWLDeprecatedProperty);
    handlerNotImplemented(OWLFunctionalProperty);
    handlerNotImplemented(OWLInverseFunctionalProperty);
    handlerNotImplemented(OWLIrreflexiveProperty);
    handlerNotImplemented(OWLNamedIndividual);
    handlerNotImplemented(OWLNegativePropertyAssertion);
    handlerNotImplemented(OWLOntology);
    handlerNotImplemented(OWLOntologyProperty);
    handlerNotImplemented(OWLReflexiveProperty);
    handlerNotImplemented(OWLRestriction);
    handlerNotImplemented(OWLSymmetricProperty);
    handlerNotImplemented(OWLTransitiveProperty);
    
    return map;
}

SYNTHESIZE_LAZY(NSDictionary, predicateHandlerMap)
{
    NSMutableDictionary<NSString *, OWLStatementHandler> *map = [[NSMutableDictionary alloc] init];
    NSString *key = nil;
    
    // rdf:type handler
    key = [OWLRDFVocabulary RDFType].stringValue;
    map[key] = [pRDFTypeHandler copy];
    
    return map;
}

#pragma mark Public methods

- (id<OWLOntology>)parseOntologyFromDocumentAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    NSParameterAssert(URL);
    
    NSError *__autoreleasing localError = nil;
    id<OWLOntology> ontology = nil;
    
    if ([self _parseOntologyAtURL:URL error:&localError]) {
        ontology = [self _parsedOntologyWithURL:URL];
    }
    
    if (error) {
        *error = localError;
    }
    
    return localError ? nil : ontology;
}

#pragma mark Private methods

- (void)initializeDataStructures
{
    [self.declarations removeAllObjects];
    [self.errors removeAllObjects];
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
        if (handler && !handler(statement, weakSelf, &localError)) {
            goto err;
        }
    } else {
        // Error: OWL predicates must be resource nodes
        localError = [NSError OWLErrorWithCode:OWLErrorCodeParse
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

- (id <OWLOntology>)_parsedOntologyWithURL:(NSURL *)URL
{
    OWLOntologyBuilder *builder = [[OWLOntologyBuilder alloc] init];
    builder.ontologyIRI = URL;
    
    // Declarations
    [self.declarations enumerateKeysAndObjectsUsingBlock:^(NSURL * _Nonnull key, NSNumber * _Nonnull obj, __unused BOOL * _Nonnull stop) {
        [builder addDeclarationOfType:[obj integerValue] withIRI:key];
    }];
    
    return [builder buildOWLOntology];
}

@end
