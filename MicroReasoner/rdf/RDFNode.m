//
//  RDFNode.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 23/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "RDFNode.h"
#import "redland.h"

@implementation RDFNode

@synthesize type = _type;
@synthesize URIStringValue = _URIStringValue;
@synthesize blankID = _blankID;
@synthesize literalValue = _literalValue;

- (BOOL)isResource { return _type == RDFNodeTypeResource; }

- (BOOL)isBlank { return _type == RDFNodeTypeBlank; }

- (BOOL)isLiteral { return _type == RDFNodeTypeLiteral; }

- (instancetype)initWithLibRdfNode:(void *)node
{
    if ((self = [super init])) {
        switch (librdf_node_get_type(node))
        {
            case LIBRDF_NODE_TYPE_RESOURCE: {
                _type = RDFNodeTypeResource;
                
                librdf_uri *uri = librdf_node_get_uri(node);
                
                if (uri) {
                    size_t length;
                    unsigned char *string_value = librdf_uri_as_counted_string(uri, &length);
                    _URIStringValue = [[NSString alloc] initWithBytes:string_value length:length encoding:NSUTF8StringEncoding];
                }
                break;
            }
                
            case LIBRDF_NODE_TYPE_BLANK: {
                _type = RDFNodeTypeBlank;
                
                size_t length;
                unsigned char *blank_id = librdf_node_get_counted_blank_identifier(node, &length);
                _blankID = [[NSString alloc] initWithBytes:blank_id length:length encoding:NSUTF8StringEncoding];
                break;
            }
                
            case LIBRDF_NODE_TYPE_LITERAL: {
                _type = RDFNodeTypeLiteral;
                
                size_t length;
                unsigned char *literal_value = librdf_node_get_literal_value_as_counted_string(node, &length);
                _literalValue = [[NSString alloc] initWithBytes:literal_value length:length encoding:NSUTF8StringEncoding];
                break;
            }
                
            default:
                break;
        }
    }
    return self;
}

- (NSString *)description
{
    NSString *description = nil;
    
    switch (_type)
    {
        case RDFNodeTypeResource:
            description = self.URIStringValue;
            break;
            
        case RDFNodeTypeBlank:
            description = self.blankID;
            break;
            
        case RDFNodeTypeLiteral:
            description = self.literalValue;
            break;
            
        default:
            break;
    }
    
    return description;
}

@end
