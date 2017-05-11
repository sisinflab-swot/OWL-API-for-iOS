//
//  Created by Ivano Bilenchi on 19/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLListItem.h"

@implementation OWLListItem

@synthesize first = _first;

- (void)setFirst:(unsigned char *)first
{
    if (_first != first) {
        _first = (unsigned char *)strdup((char *)first);
    }
}

@synthesize rest = _rest;

- (void)setRest:(unsigned char *)rest
{
    if (_rest != rest) {
        _rest = (unsigned char *)strdup((char *)rest);
    }
}

- (void)dealloc
{
    free(_first);
    _first = NULL;
    
    free(_rest);
    _rest = NULL;
}

@end
