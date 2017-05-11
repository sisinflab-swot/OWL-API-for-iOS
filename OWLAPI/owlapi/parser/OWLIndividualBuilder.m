//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLIndividualBuilder.h"
#import "OWLAnonymousIndividualImpl.h"
#import "OWLError.h"
#import "OWLIRI.h"
#import "OWLNamedIndividualImpl.h"
#import "OWLNodeID.h"

@interface OWLIndividualBuilder ()
{
    id<OWLIndividual> _builtIndividual;
}
@end


@implementation OWLIndividualBuilder

#pragma mark OWLAbstractBuilder

- (id<OWLIndividual>)build
{
    if (_builtIndividual) {
        return _builtIndividual;
    }
    
    id<OWLIndividual> builtIndividual = nil;
    
    switch (_type)
    {
        case OWLIBTypeNamed: {
            if (_IRI) {
                OWLIRI *IRI = [[OWLIRI alloc] initWithString:(NSString *_Nonnull)_IRI];
                builtIndividual = [[OWLNamedIndividualImpl alloc] initWithIRI:IRI];
            }
            break;
        }
            
        case OWLIBTypeAnonymous: {
            builtIndividual = [[OWLAnonymousIndividualImpl alloc] initWithNodeID:OWLNodeID_new()];
            break;
        }
            
        default:
            break;
    }
    
    if (builtIndividual) {
        _builtIndividual = builtIndividual;
        _IRI = nil;
    }
    
    return builtIndividual;
}

#pragma mark General

SYNTHESIZE_BUILDER_VALUE_PROPERTY(OWLIBType, type, Type, @"Multiple types for individual.")
SYNTHESIZE_BUILDER_STRING_PROPERTY(IRI, IRI, @"Multiple IRIs for individual.")

@end
