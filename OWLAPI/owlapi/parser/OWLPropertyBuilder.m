//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLPropertyBuilder.h"
#import "OWLError.h"
#import "OWLIRI.h"
#import "OWLObjectPropertyImpl.h"

@interface OWLPropertyBuilder ()
{
    id<OWLPropertyExpression> _builtProperty;
}
@end


@implementation OWLPropertyBuilder

#pragma mark Lifecycle

- (void)dealloc
{
    [self free];
}

- (void)free
{
    free(_IRI);
    _IRI = NULL;
}

#pragma mark OWLAbstractBuilder

- (id<OWLPropertyExpression>)build
{
    if (_builtProperty) {
        return _builtProperty;
    }
    
    id<OWLPropertyExpression> builtProperty = nil;
    
    switch(_type)
    {
        case OWLPBTypeObjectProperty:
        {
            if (_IRI) {
                OWLIRI *IRI = [[OWLIRI alloc] initWithCString:(unsigned char *_Nonnull)_IRI];
                builtProperty = [[OWLObjectPropertyImpl alloc] initWithIRI:IRI];
            }
            break;
        }
            
        default:
            break;
    }
    
    if (builtProperty) {
        _builtProperty = builtProperty;
        [self free];
    }
    return builtProperty;
}

#pragma mark General

SYNTHESIZE_BUILDER_VALUE_PROPERTY(OWLPBType, type, Type, @"Multiple types for property.")


#pragma mark Named property

SYNTHESIZE_BUILDER_CSTRING_PROPERTY(IRI, IRI, @"Multiple IRIs for named property.")

@end
