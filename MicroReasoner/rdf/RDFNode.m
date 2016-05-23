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

- (void)dealloc
{
    if (_owner) {
        librdf_free_node(_wrappedObject);
    }
}

- (RDFNodeType)type
{
    return (RDFNodeType)librdf_node_get_type(_wrappedObject);
}

- (BOOL)isResource
{
    return librdf_node_is_resource(_wrappedObject) != 0;
}

- (BOOL)isBlank
{
    return librdf_node_is_blank(_wrappedObject) != 0;
}

- (BOOL)isLiteral
{
    return librdf_node_is_literal(_wrappedObject) != 0;
}

- (NSString *)URIStringValue
{
    NSString *stringValue = nil;
    librdf_uri *uri = librdf_node_get_uri(_wrappedObject);
    
    if (uri) {
        size_t length;
        unsigned char *string_value = librdf_uri_as_counted_string(uri, &length);
        stringValue = [[NSString alloc] initWithBytes:string_value length:length encoding:NSUTF8StringEncoding];
    }
    return stringValue;
}

- (NSString *)blankID
{
    char *blank_id = (char *)librdf_node_get_blank_identifier(_wrappedObject);
    return [[NSString alloc] initWithUTF8String:blank_id];
}

- (NSString *)literalValue
{
    size_t length;
    unsigned char *literal_value;
    
    literal_value = librdf_node_get_literal_value_as_counted_string(_wrappedObject, &length);
    return [[NSString alloc] initWithBytes:literal_value length:length encoding:NSUTF8StringEncoding];
}

@end
