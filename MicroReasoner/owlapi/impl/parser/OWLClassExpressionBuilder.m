//
//  OWLClassExpressionBuilder.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 16/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClassExpressionBuilder.h"
#import "OWLClassImpl.h"
#import "OWLError.h"

@implementation OWLClassExpressionBuilder

#pragma mark OWLAbstractBuilder

- (id<OWLClassExpression>)build
{
    id<OWLClassExpression> builtClassExpression = nil;
    
    switch(self.type) {
        case OWLCEBTypeClass:
        {
            NSString *classID = self.classID;
            if (classID) {
                NSURL *IRI = [[NSURL alloc] initWithString:classID];
                if (IRI) {
                    builtClassExpression = [[OWLClassImpl alloc] initWithIRI:IRI];
                }
            }
            break;
        }
            
        default:
            break;
    }
    
    return builtClassExpression;
}

#pragma mark General

// type
@synthesize type = _type;

- (BOOL)setType:(OWLCEBType)type error:(NSError *__autoreleasing *)error
{
    if (_type == type) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (_type == OWLCEBTypeUnknown) {
        _type = type;
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple types for class expression."
                                  userInfo:@{@"types": @[@(_type), @(type)]}];
    }
    
    return success;
}

#pragma mark Class

// classID
@synthesize classID = _classID;

- (BOOL)setClassID:(NSString *)ID error:(NSError *__autoreleasing *)error
{
    if (_classID == ID || [_classID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_classID) {
        _classID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple IRIs for class."
                                  userInfo:@{@"IRIs": @[_classID, ID]}];
    }
    
    return success;
}

#pragma mark Restriction

// restrictionType
@synthesize restrictionType = _restrictionType;

- (BOOL)setRestrictionType:(OWLCEBRestrictionType)type error:(NSError *__autoreleasing *)error
{
    if (_restrictionType == type) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (_restrictionType == OWLCEBRestrictionTypeUnknown) {
        _restrictionType = type;
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple types for restriction."
                                  userInfo:@{@"types": @[@(_restrictionType), @(type)]}];
    }
    
    return success;
}

// propertyID
@synthesize propertyID = _propertyID;

- (BOOL)setPropertyID:(NSString *)ID error:(NSError *__autoreleasing *)error
{
    if (_propertyID == ID || [_propertyID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_propertyID) {
        _propertyID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple 'onProperty' statements for restriction."
                                  userInfo:@{@"propertyIDs": @[_propertyID, ID]}];
    }
    
    return success;
}

// fillerID
@synthesize fillerID = _fillerID;

- (BOOL)setFillerID:(NSString *)ID error:(NSError *__autoreleasing *)error
{
    if (_fillerID == ID || [_fillerID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_fillerID) {
        _fillerID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple fillers for restriction."
                                  userInfo:@{@"fillerIDs": @[_fillerID, ID]}];
    }
    
    return success;
}

#pragma mark Lifecycle

- (instancetype)init
{
    if ((self = [super init])) {
        _type = OWLCEBTypeUnknown;
        _restrictionType = OWLCEBRestrictionTypeUnknown;
    }
    return self;
}

@end
