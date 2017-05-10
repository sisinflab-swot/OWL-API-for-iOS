//
//  Created by Ivano Bilenchi on 23/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "RDFNode.h"

@implementation RDFNode
{
    raptor_term *_term;
}

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
        _term = term;
        
        switch (term->type)
        {
            case RAPTOR_TERM_TYPE_URI: {
                _type = RDFNodeTypeResource;
                break;
            }
                
            case RAPTOR_TERM_TYPE_BLANK: {
                _type = RDFNodeTypeBlank;
                break;
            }
                
            case RAPTOR_TERM_TYPE_LITERAL: {
                _type = RDFNodeTypeLiteral;
                break;
            }
                
            default:
                break;
        }
    }
    return self;
}

- (NSString *)URIStringValue
{
    NSString *stringValue = nil;
    
    if (_type == RDFNodeTypeResource) {
        if (_URIStringValue) {
            stringValue = _URIStringValue;
        } else {
            size_t len;
            unsigned char *str = raptor_uri_as_counted_string(_term->value.uri, &len);
            stringValue = [[NSString alloc] initWithBytes:(const void *_Nonnull)str length:len encoding:NSUTF8StringEncoding];
            
            _URIStringValue = stringValue;
        }
    }
    
    return stringValue;
}

- (NSString *)blankID
{
    NSString *blankID = nil;
    
    if (_type == RDFNodeTypeBlank) {
        if (_blankID) {
            blankID = _blankID;
        } else {
            raptor_term_blank_value blank = _term->value.blank;
            blankID = [[NSString alloc] initWithBytes:blank.string length:blank.string_len encoding:NSUTF8StringEncoding];
            
            _blankID = blankID;
        }
    }
    
    return blankID;
}

- (NSString *)literalValue
{
    NSString *literalValue = nil;
    
    if (_type == RDFNodeTypeLiteral) {
        if (_literalValue) {
            literalValue = _literalValue;
        } else {
            raptor_term_literal_value value = _term->value.literal;
            literalValue = [[NSString alloc] initWithBytes:value.string length:value.string_len encoding:NSUTF8StringEncoding];
            
            _literalValue = literalValue;
        }
    }
    
    return literalValue;
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

- (unsigned char *)cURI
{
    return raptor_uri_as_string(_term->value.uri);
}

@end
