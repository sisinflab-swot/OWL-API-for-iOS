//
//  Created by Ivano Bilenchi on 10/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OWLIRI;
@class OWLNamespace;

NS_ASSUME_NONNULL_BEGIN

/// OWL namespace.
extern OWLNamespace *OWLNamespaceOWL;

/// RDF syntax namespace.
extern OWLNamespace *OWLNamespaceRDFSyntax;

/// RDF Schema namespace.
extern OWLNamespace *OWLNamespaceRDFSchema;


/// Represents OWL/RDF namespaces.
@interface OWLNamespace : NSObject <NSCopying>

/// The prefix of this namespace.
@property (nonatomic, copy, readonly) NSString *prefix;

/// The short name of this namespace.
@property (nonatomic, copy, readonly) NSString *shortName;

/// The designated initializer.
- (instancetype)initWithPrefix:(NSString *)prefix shortName:(NSString *)shortName;

/**
 *  Returns a new OWLIRI by appending the given fragment to the prefix of this namespace.
 *
 *  @param fragment Fragment to append to the prefix.
 *
 *  @return The created OWLIRI instance.
 */
- (OWLIRI *)IRIWithFragment:(NSString *)fragment;

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
