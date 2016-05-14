//
//  OWLRDFXMLParser.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLRDFXMLParser.h"
#import "OWLEntityType.h"
#import "OWLNamespace.h"
#import "OWLOntologyBuilder.h"
#import "OWLRDFVocabulary.h"
#import "SMRPreprocessor.h"
#import <Redland-ObjC.h>

@interface OWLRDFXMLParser ()

/// IRI -> NSNumber enclosing OWLEntityType
@property (nonatomic, strong, readonly) NSMutableDictionary<NSURL*,NSNumber*> *declarations;

@end


@implementation OWLRDFXMLParser

#pragma mark Properties

SYNTHESIZE_LAZY_INIT(NSMutableDictionary, declarations);

#pragma mark Public methods

- (id<OWLOntology>)parseOntologyFromDocumentAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    NSParameterAssert(URL);
    
    NSError *localError = nil;
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

- (BOOL)_parseOntologyAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    // Return vars
    NSError *localError = nil;
    
    // Work vars
    RedlandParser *parser = [[RedlandParser alloc] initWithName:RedlandRDFXMLParserName];
    RedlandURI *baseURI = [RedlandURI URIWithString:OWLNamespaceRDFSyntax.prefix];
    RedlandStream *stream = nil;
    
    // OWL vocabulary strings
    NSString *rdfTypeURIString = [OWLRDFVocabulary RDFType].stringValue;
    NSString *owlClassURIString = [OWLRDFVocabulary OWLClass].stringValue;
    NSString *owlObjectPropertyURIString = [OWLRDFVocabulary OWLObjectProperty].stringValue;
    
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
    
    for (RedlandStatement *stmt in stream.statementEnumerator) {
        
        // Parse declarations
        RedlandNode *predicate = stmt.predicate;
        
        if (predicate.isResource && [predicate.URIStringValue isEqualToString:rdfTypeURIString]) {
            RedlandNode *object = stmt.object;
            
            if (object.isResource)
            {
                NSString *objectURIString = object.URIStringValue;
                
                BOOL isDeclaration = NO;
                OWLEntityType declaredEntityType = OWLEntityTypeClass;
                
                if ([objectURIString isEqualToString:owlClassURIString]) {
                    // OWL Class declaration
                    isDeclaration = YES;
                    declaredEntityType = OWLEntityTypeClass;
                } else if ([objectURIString isEqualToString:owlObjectPropertyURIString]) {
                    // OWL Object Property declaration
                    isDeclaration = YES;
                    declaredEntityType = OWLEntityTypeObjectProperty;
                }
                
                if (isDeclaration) {
                    RedlandNode *subject = stmt.subject;
                    NSURL *IRI = subject.isResource ? subject.URIValue.URLValue : nil;
                    
                    if (IRI) {
                        self.declarations[IRI] = [NSNumber numberWithInteger:declaredEntityType];
                    }
                }
            }
        }
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
