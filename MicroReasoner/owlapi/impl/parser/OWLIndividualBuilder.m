//
//  OWLIndividualBuilder.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLIndividualBuilder.h"
#import "OWLAnonymousIndividualImpl.h"
#import "OWLError.h"
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
    NSString *ID = _ID;
    
    if (ID) {
        switch (_type)
        {
            case OWLIBTypeNamed: {
                NSURL *IRI = [[NSURL alloc] initWithString:ID];
                if (IRI) {
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
    }
    
    if (builtIndividual) {
        _builtIndividual = builtIndividual;
        _ID = nil;
    }
    return builtIndividual;
}

#pragma mark General

// type
@synthesize type = _type;

- (BOOL)setType:(OWLIBType)type error:(NSError *__autoreleasing *)error
{
    if (_type == type) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (_type == OWLIBTypeUnknown) {
        _type = type;
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple types for individual."
                                  userInfo:@{@"types": @[@(_type), @(type)]}];
    }
    
    return success;
}

// ID
@synthesize ID = _ID;

- (BOOL)setID:(NSString *)ID error:(NSError *__autoreleasing *)error
{
    if (_ID == ID || [_ID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_ID) {
        _ID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple IRIs for individual."
                                  userInfo:@{@"individualIDs": @[_ID, ID]}];
    }
    
    return success;
}

@end
