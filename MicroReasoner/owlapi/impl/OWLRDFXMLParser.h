//
//  OWLRDFXMLParser.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OWLOntology;

NS_ASSUME_NONNULL_BEGIN

/// Parses OWL RDF/XML documents into structured ontologies.
@interface OWLRDFXMLParser : NSObject

/**
 * Parses the document at the specified URL.
 *
 * @param URL The URL of the document to parse.
 * @param error Error out parameter.
 *
 * @return OWLOntology representation of the parsed document, or nil on error.
 */
- (nullable id<OWLOntology>)parseOntologyFromDocumentAtURL:(NSURL *)URL error:(NSError *_Nullable __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
