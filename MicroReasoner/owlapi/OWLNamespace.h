//
//  OWLNamespace.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 10/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OWLNamespace;

NS_ASSUME_NONNULL_BEGIN

extern OWLNamespace *OWLNamespaceOWL;               /// OWL namespace.
extern OWLNamespace *OWLNamespaceRDFSyntax;         /// RDF syntax namespace.
extern OWLNamespace *OWLNamespaceRDFSchema;         /// RDF Schema namespace.


/// Represents OWL/RDF namespaces.
@interface OWLNamespace : NSObject <NSCopying>

/// The prefix of this namespace.
@property (nonatomic, copy, readonly) NSString *prefix;

/// The short name of this namespace.
@property (nonatomic, copy, readonly) NSString *shortName;

/// The designated initializer.
- (instancetype)initWithPrefix:(NSString *)prefix shortName:(NSString *)shortName;

/**
 *  Returns a new NSURL by appending the given fragment to the prefix of this namespace.
 *
 *  @param fragment Fragment to append to the prefix.
 *
 *  @return The created NSURL instance.
 */
- (NSURL *)URLWithFragment:(NSString *)fragment;

/**
 *  Returns a new NSString by appending the given fragment to the prefix of this namespace.
 *
 *  @param fragment Fragment to append to the prefix.
 *
 *  @return The created NSString instance.
 */
- (NSString *)stringWithFragment:(NSString *)fragment;

@end

NS_ASSUME_NONNULL_END
