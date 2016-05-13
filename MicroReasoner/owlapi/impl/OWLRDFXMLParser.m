//
//  OWLRDFXMLParser.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLRDFXMLParser.h"
#import "OWLNamespace.h"
#import "OWLOntologyBuilder.h"
#import "OWLRDFVocabulary.h"
#import <Redland-ObjC.h>

@implementation OWLRDFXMLParser

#pragma mark Public methods

- (id<OWLOntology>)parseOntologyFromDocumentAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    NSParameterAssert(URL);
    
    // Return vars
    OWLOntologyBuilder *builder = [[OWLOntologyBuilder alloc] init];
    builder.ontologyIRI = URL;
    
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
                BOOL isClassDeclaration = NO;
                BOOL isObjPropDeclaration = NO;
                
                if ([objectURIString isEqualToString:owlClassURIString]) {
                    // OWL Class declaration
                    isClassDeclaration = YES;
                } else if ([objectURIString isEqualToString:owlObjectPropertyURIString]) {
                    // OWL Object Property declaration
                    isObjPropDeclaration = YES;
                }
                
                if (isClassDeclaration || isObjPropDeclaration) {
                    RedlandNode *subject = stmt.subject;
                    NSURL *IRI = subject.isResource ? subject.URIValue.URLValue : nil;
                    
                    if (IRI) {
                        if (isClassDeclaration) {
                            [builder addClassDeclarationAxiomForIRI:IRI];
                        } else {
                            [builder addObjectPropertyDeclarationAxiomForIRI:IRI];
                        }
                    }
                }
            }
        }
        
        // Add to 'allStatements' array
        [builder addStatement:stmt];
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return localError ? nil : [builder buildOWLOntology];
}

@end
