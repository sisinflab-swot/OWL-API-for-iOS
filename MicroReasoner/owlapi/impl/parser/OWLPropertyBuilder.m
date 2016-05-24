//
//  OWLPropertyBuilder.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLPropertyBuilder.h"
#import "OWLError.h"
#import "OWLObjectPropertyImpl.h"

@interface OWLPropertyBuilder ()
{
    id<OWLPropertyExpression> _builtProperty;
}
@end


@implementation OWLPropertyBuilder

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
            NSString *ID = _namedPropertyID;
            if (ID) {
                NSURL *IRI = [[NSURL alloc] initWithString:ID];
                if (IRI) {
                    builtProperty = [[OWLObjectPropertyImpl alloc] initWithIRI:IRI];
                }
            }
            break;
        }
            
        default:
            break;
    }
    
    if (builtProperty) {
        _builtProperty = builtProperty;
        _namedPropertyID = nil;
    }
    return builtProperty;
}

#pragma mark General

// type
@synthesize type = _type;

- (BOOL)setType:(OWLPBType)type error:(NSError *__autoreleasing *)error
{
    if (_type == type) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (_type == OWLPBTypeUnknown) {
        _type = type;
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple types for property."
                                  userInfo:@{@"types": @[@(_type), @(type)]}];
    }
    
    return success;
}

#pragma mark Named property

// namedPropertyID
@synthesize namedPropertyID = _namedPropertyID;

- (BOOL)setNamedPropertyID:(NSString *)ID error:(NSError *__autoreleasing  _Nullable *)error
{
    if (_namedPropertyID == ID || [_namedPropertyID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_namedPropertyID) {
        _namedPropertyID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple IRIs for named property."
                                  userInfo:@{@"IRIs": @[_namedPropertyID, ID]}];
    }
    
    return success;
}

#pragma mark Lifecycle

- (instancetype)init
{
    if ((self = [super init])) {
        _type = OWLPBTypeUnknown;
    }
    return self;
}

@end
