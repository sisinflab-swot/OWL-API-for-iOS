//
//  Created by Ivano Bilenchi on 23/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "RDFNode.h"
#import "OWLIRI.h"

@implementation RDFNode
{
    raptor_term *_term;
}

@synthesize type = _type;
@synthesize cValue = _cValue;

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
                _cValue = raptor_uri_as_string(term->value.uri);
                break;
            }
                
            case RAPTOR_TERM_TYPE_BLANK: {
                _type = RDFNodeTypeBlank;
                _cValue = term->value.blank.string;
                break;
            }
                
            case RAPTOR_TERM_TYPE_LITERAL: {
                _type = RDFNodeTypeLiteral;
                _cValue = term->value.literal.string;
                break;
            }
                
            default:
                break;
        }
    }
    return self;
}

- (NSString *)IRIValue
{
    NSString *IRIValue = nil;
    
    if (_type == RDFNodeTypeResource) {
        size_t len;
        unsigned char *str = raptor_uri_as_counted_string(_term->value.uri, &len);
        IRIValue = [[NSString alloc] initWithBytes:(const void *_Nonnull)str length:len encoding:NSUTF8StringEncoding];
    }
    
    return IRIValue;
}

- (NSString *)blankIDValue
{
    NSString *blankIDValue = nil;
    
    if (_type == RDFNodeTypeBlank) {
        raptor_term_blank_value blank = _term->value.blank;
        blankIDValue = [[NSString alloc] initWithBytes:blank.string length:blank.string_len encoding:NSUTF8StringEncoding];
    }
    
    return blankIDValue;
}

- (NSString *)literalValue
{
    NSString *literalValue = nil;
    
    if (_type == RDFNodeTypeLiteral) {
        raptor_term_literal_value value = _term->value.literal;
        literalValue = [[NSString alloc] initWithBytes:value.string length:value.string_len encoding:NSUTF8StringEncoding];
    }
    
    return literalValue;
}

- (NSString *)description
{
    switch (_type)
    {
        case RDFNodeTypeResource:
            return self.IRIValue;
            
        case RDFNodeTypeBlank:
            return self.blankIDValue;
            
        case RDFNodeTypeLiteral:
            return self.literalValue;
            
        default:
            return nil;
    }
}

@end
