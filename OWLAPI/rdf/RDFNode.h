//
//  Created by Ivano Bilenchi on 23/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "raptor.h"

typedef NS_ENUM(NSInteger, RDFNodeType) {
    RDFNodeTypeUnknown,
    RDFNodeTypeResource,
    RDFNodeTypeLiteral,
    RDFNodeTypeBlank
};

NS_ASSUME_NONNULL_BEGIN

/// Represents nodes of the RDF graph.
@interface RDFNode : NSObject

/// The type of this node.
@property (nonatomic, readonly) RDFNodeType type;

/// Specifies whether this node is a resource node.
@property (nonatomic, readonly) BOOL isResource;

/// Specifies whether this node is a blank node.
@property (nonatomic, readonly) BOOL isBlank;

/// Specifies whether this node is a literal node.
@property (nonatomic, readonly) BOOL isLiteral;

/**
 The URI of this node if it is a resource node, nil otherwise.
 
 @note This is a shared pointer which is only valid while raptor is parsing.
 */
@property (nonatomic, readonly, nullable) unsigned char *cURI;

/// The URI string value of this node if it is a resource node, nil otherwise.
@property (nonatomic, copy, readonly, nullable) NSString *URIStringValue;

/// The blank ID of this node if it is a blank node, nil otherwise.
@property (nonatomic, copy, readonly, nullable) NSString *blankID;

/// The literal value of this node if it is a literal node, nil otherwise.
@property (nonatomic, copy, readonly, nullable) NSString *literalValue;

- (instancetype)initWithRaptorTerm:(raptor_term *)term;

@end

NS_ASSUME_NONNULL_END
