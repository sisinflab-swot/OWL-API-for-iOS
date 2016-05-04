//
//  OWLOntologyManagerImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntologyManagerImpl.h"
#import "OWLOntologyID.h"
#import "OWLClassImpl.h"
#import "OWLOntologyImpl.h"
#import "OWLOntologyInternals.h"

#import "RedlandNamespace+OWLAdditions.h"
#import <Redland-ObjC.h>

@implementation OWLOntologyManagerImpl

#pragma mark Public methods

- (id<OWLOntology>)loadOntologyFromDocumentAtURL:(NSURL *)URL error:(NSError *__autoreleasing _Nullable *)error
{
    NSParameterAssert(URL);
    
    NSError *localError = nil;
    id <OWLOntology> onto = [self _parseFileAtURL:URL error:&localError];
    
    if (error) {
        *error = localError;
    }
    
    return localError ? nil : onto;
}

#pragma mark Private methods

- (OWLOntologyImpl *)_parseFileAtURL:(NSURL *)URL error:(NSError *__autoreleasing _Nullable *)error
{
    NSParameterAssert(URL);
    
    NSError *localError = nil;
    OWLOntologyImpl *onto = nil;
    
    RedlandParser *parser = nil;
    RedlandURI *baseURI = nil;
    RedlandStream *stream = nil;
    OWLOntologyInternals *internals = nil;
    
    NSString *rdfTypeURIString = nil;
    NSString *owlClassURIString = nil;
    
    NSString *ontoString = [[NSString alloc] initWithContentsOfURL:URL
                                                      usedEncoding:NULL
                                                             error:&localError];
    
    if (!ontoString) {
        goto err;
    }
    
    parser = [[RedlandParser alloc] initWithName:RedlandRDFXMLParserName];
    baseURI = [RedlandURI URIWithString:RDFSyntaxNS.prefix];
    internals = [[OWLOntologyInternals alloc] init];
    
    // OWL syntax
    rdfTypeURIString = [RDFSyntaxNS string:@"type"];
    owlClassURIString = [OWLSyntaxNS string:@"Class"];
    
    // Parse loop
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
                    [internals.classesByIRI setObject:owlClass forKey:iri];
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
    
    if (!localError) {
        OWLOntologyID *ID = [[OWLOntologyID alloc] initWithOntologyIRI:URL];
        onto = [[OWLOntologyImpl alloc] initWithID:ID internals:internals];
    }
    
    return onto;
}

@end
