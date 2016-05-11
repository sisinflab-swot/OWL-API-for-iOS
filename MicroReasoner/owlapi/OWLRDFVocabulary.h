//
//  OWLRDFVocabulary.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 10/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OWLNamespace;

NS_ASSUME_NONNULL_BEGIN

/// Represents a term in the OWL RDF vocabulary.
@interface OWLRDFTerm : NSObject

/// The IRI of this term.
@property (nonatomic, copy, readonly) NSURL *IRI;

/// The namespace of this term.
@property (nonatomic, copy, readonly) OWLNamespace *nameSpace;

/// The short name of this term.
@property (nonatomic, copy, readonly) NSString *shortName;

/// The designated initializer.
- (instancetype)initWithNameSpace:(OWLNamespace *)nameSpace shortName:(NSString *)shortName;

/**
 * Returns the concatenation of the namespace and short name of this term.
 *
 * @return The string representation of this term.
 */
- (NSString *)stringValue;

@end


/// Represents the OWL RDF vocabulary.
@interface OWLRDFVocabulary : NSObject

+ (OWLRDFTerm *)RDFType;

+ (OWLRDFTerm *)OWLClass;
+ (OWLRDFTerm *)OWLThing;
+ (OWLRDFTerm *)OWLNothing;

@end

NS_ASSUME_NONNULL_END