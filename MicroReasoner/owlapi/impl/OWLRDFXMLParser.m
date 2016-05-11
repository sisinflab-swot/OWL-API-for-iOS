//
//  OWLRDFXMLParser.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLRDFXMLParser.h"
#import "OWLClassImpl.h"
#import "OWLNamespace.h"
#import "OWLOntologyID.h"
#import "OWLOntologyImpl.h"
#import "OWLOntologyInternals.h"
#import "OWLRDFVocabulary.h"
#import <Redland-ObjC.h>

@implementation OWLRDFXMLParser

#pragma mark Public methods

- (id<OWLOntology>)parseOntologyFromDocumentAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    NSParameterAssert(URL);
    
    NSError *localError = nil;
    OWLOntologyImpl *ontology = nil;
    
    OWLOntologyInternals *internals = [self _parseFileAtURL:URL error:&localError];
    
    if (error) {
        *error = localError;
    }
    
    if (internals) {
        OWLOntologyID *ID = [[OWLOntologyID alloc] initWithOntologyIRI:URL];
        ontology = [[OWLOntologyImpl alloc] initWithID:ID internals:internals];
    }
    
    return ontology;
}

#pragma mark Private methods

- (OWLOntologyInternals *)_parseFileAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error
{
    // Return vars
    OWLOntologyInternals *internals = [[OWLOntologyInternals alloc] init];
    NSError *localError = nil;
    
    // Work vars
    RedlandParser *parser = [[RedlandParser alloc] initWithName:RedlandRDFXMLParserName];
    RedlandURI *baseURI = [RedlandURI URIWithString:OWLNamespaceRDFSyntax.prefix];
    RedlandStream *stream = nil;
    
    // OWL vocabulary strings
    NSString *rdfTypeURIString = [OWLRDFVocabulary RDFType].stringValue;
    NSString *owlClassURIString = [OWLRDFVocabulary OWLClass].stringValue;
    
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
        
        // Parse classes
        RedlandNode *predicate = stmt.predicate;
        
        if (predicate.isResource && [predicate.URIStringValue isEqualToString:rdfTypeURIString]) {
            RedlandNode *object = stmt.object;
            
            if (object.isResource && [object.URIStringValue isEqualToString:owlClassURIString]) {
                RedlandNode *subject = stmt.subject;
                NSURL *iri = subject.isResource ? subject.URIValue.URLValue : nil;
                
                if (iri) {
                    OWLClassImpl *owlClass = [[OWLClassImpl alloc] initWithIRI:iri];
                    internals.classesByIRI[iri] = owlClass;
                }
            }
        }
        
        // Add to 'allStatements' array
        [internals.allStatements addObject:stmt];
    }
    
    //    // Hash table implementation, probably faster for the final parser
    //    // Parser directives
    //    void (^parseClass)(RedlandNode *) = ^(RedlandNode *node) {
    //        NSURL *iri = node.isResource ? node.URIValue.URLValue : nil;
    //
    //        if (iri) {
    //            OWLClass *owlClass = [[OWLClass alloc] initWithIRI:iri];
    //            [self.pClassesInSignature setObject:owlClass forKey:iri];
    //        }
    //    };
    //
    //    // Parser hash table
    //    NSString *const separator = @"|#|";
    //    NSDictionary<NSString *, void (^)(RedlandNode*)> *parserTable = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                                                                     [parseClass copy], [NSString stringWithFormat:@"%@%@%@", rdfTypeURIString, separator, owlClassURIString],
    //                                                                     nil];
    //
    //    // Parse loop
    //    RedlandStream *stream = [parser parseString:ontoString asStreamWithBaseURI:baseUri error:NULL];
    //    if (stream) {
    //        for (RedlandStatement *stmt in stream.statementEnumerator) {
    //
    //            // Parse classes
    //            RedlandNode *predicate = stmt.predicate;
    //            RedlandNode *object = stmt.object;
    //
    //            if (predicate.isResource && object.isResource) {
    //                NSMutableString *key = [[NSMutableString alloc] initWithString:predicate.URIStringValue];
    //                [key appendString:separator];
    //                [key appendString:object.URIStringValue];
    //
    //                void (^parserBlock)(RedlandNode *) = [parserTable objectForKey:key];
    //                if (parserBlock) {
    //                    parserBlock(stmt.subject);
    //                }
    //            }
    //
    //            // Add to 'allStatements' array
    //            [self.pAllStatements addObject:stmt];
    //        }
    //    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return localError ? nil : internals;
}

@end
