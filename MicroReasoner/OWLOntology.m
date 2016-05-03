//
//  OWLOntology.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntology.h"
#import "OWLClass.h"
#import <Redland-ObjC.h>

static RedlandNamespace *OWLSyntaxNS = nil;


@interface OWLOntology ()

@property (nonatomic, strong, readonly) NSMutableArray<RedlandStatement *> *pAllStatements;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSURL *, OWLClass *> *pClassesInSignature;

@property (nonatomic, copy) NSURL *fileURL;

@end


@implementation OWLOntology

#pragma mark Properties

// allStatements
- (NSArray<RedlandStatement *> *)allStatements
{
    return [NSArray arrayWithArray:self.pAllStatements];
}

@synthesize pAllStatements = _pAllStatements;

- (NSMutableArray<RedlandStatement *> *)pAllStatements
{
    if (!_pAllStatements) {
        _pAllStatements = [[NSMutableArray alloc] init];
        [self _parseFile];
    }
    return _pAllStatements;
}

// classesInSignature
- (NSDictionary<NSURL *,OWLClass *> *)classesInSignature
{
    return [NSDictionary dictionaryWithDictionary:self.pClassesInSignature];
}

@synthesize pClassesInSignature = _pClassesInSignature;

- (NSMutableDictionary<NSURL *,OWLClass *> *)pClassesInSignature
{
    if (!_pClassesInSignature) {
        _pClassesInSignature = [[NSMutableDictionary alloc] init];
        [self _parseFile];
    }
    return _pClassesInSignature;
}

// Others
@synthesize fileURL = _fileURL;

#pragma mark Public methods

+ (void)initialize
{
    if (self == [OWLOntology class]) {
        OWLSyntaxNS = [[RedlandNamespace alloc] initWithPrefix:@"http://www.w3.org/2002/07/owl#" shortName:@"owl"];
    }
}

- (instancetype)initWithContentsOfURL:(NSURL *)url
{
    if ((self = [super init])) {
        _fileURL = [url copy];
    }
    return self;
}

#pragma mark Private methods

- (void)_parseFile
{
    NSString *ontoString = [[NSString alloc] initWithContentsOfURL:self.fileURL usedEncoding:NULL error:NULL];
    
    if (!ontoString) {
        return;
    }
    
    RedlandParser *parser = [[RedlandParser alloc] initWithName:RedlandRDFXMLParserName];
    RedlandURI *baseUri = [RedlandURI URIWithString:RDFSyntaxNS.prefix];
    
    // OWL syntax
    NSString *rdfTypeURIString = [RDFSyntaxNS string:@"type"];
    NSString *owlClassURIString = [OWLSyntaxNS string:@"Class"];
    
    // Parse loop
    RedlandStream *stream = [parser parseString:ontoString asStreamWithBaseURI:baseUri error:NULL];
    if (stream) {
        for (RedlandStatement *stmt in stream.statementEnumerator) {
            // Parse classes
            RedlandNode *predicate = stmt.predicate;
            
            if (predicate.isResource && [predicate.URIStringValue isEqualToString:rdfTypeURIString]) {
                RedlandNode *object = stmt.object;
                
                if (object.isResource && [object.URIStringValue isEqualToString:owlClassURIString]) {
                    RedlandNode *subject = stmt.subject;
                    NSURL *iri = subject.isResource ? subject.URIValue.URLValue : nil;
                    
                    if (iri) {
                        OWLClass *owlClass = [[OWLClass alloc] initWithIRI:iri];
                        [self.pClassesInSignature setObject:owlClass forKey:iri];
                    }
                }
            }
            
            // Add to 'allStatements' array
            [self.pAllStatements addObject:stmt];
        }
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
}

@end
