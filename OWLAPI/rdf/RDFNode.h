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
 The URI, blank ID or literal value of this node.
 
 @note This is a shared pointer which is only valid while raptor is parsing.
 */
@property (nonatomic, readonly) unsigned char *cValue;

/// The IRI of this node if it is a resource node, nil otherwise.
@property (nonatomic, copy, readonly) NSString *IRIValue;

/// The blank ID of this node if it is a blank node, nil otherwise.
@property (nonatomic, copy, readonly) NSString *blankIDValue;

/// The literal value of this node if it is a literal node, nil otherwise.
@property (nonatomic, copy, readonly) NSString *literalValue;

- (instancetype)initWithRaptorTerm:(raptor_term *)term;

@end
