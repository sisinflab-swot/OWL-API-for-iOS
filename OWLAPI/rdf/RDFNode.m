//
//  Created by Ivano Bilenchi on 23/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "RDFNode.h"

@implementation RDFNode

@synthesize type = _type;
@synthesize URIStringValue = _URIStringValue;
@synthesize blankID = _blankID;
@synthesize literalValue = _literalValue;

- (BOOL)isResource { return _type == RDFNodeTypeResource; }

- (BOOL)isBlank { return _type == RDFNodeTypeBlank; }

- (BOOL)isLiteral { return _type == RDFNodeTypeLiteral; }

- (instancetype)initWithRaptorTerm:(raptor_term *)term
{
    if ((self = [super init])) {
        switch (term->type)
        {
            case RAPTOR_TERM_TYPE_URI: {
                _type = RDFNodeTypeResource;
                raptor_uri *uri = term->value.uri;
                
                if (uri) {
                    size_t length;
                    unsigned char *string_value = raptor_uri_as_counted_string(uri, &length);
                    _URIStringValue = [[NSString alloc] initWithBytes:string_value length:length encoding:NSUTF8StringEncoding];
                }
                break;
            }
                
            case RAPTOR_TERM_TYPE_BLANK: {
                _type = RDFNodeTypeBlank;
                raptor_term_blank_value value = term->value.blank;
                _blankID = [[NSString alloc] initWithBytes:value.string length:value.string_len encoding:NSUTF8StringEncoding];
                break;
            }
                
            case RAPTOR_TERM_TYPE_LITERAL: {
                _type = RDFNodeTypeLiteral;
                raptor_term_literal_value value = term->value.literal;
                _literalValue = [[NSString alloc] initWithBytes:value.string length:value.string_len encoding:NSUTF8StringEncoding];
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
