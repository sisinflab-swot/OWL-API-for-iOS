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
#import "OWLObjectAllValuesFromImpl.h"
#import "OWLObjectExactCardinalityImpl.h"
#import "OWLObjectIntersectionOfImpl.h"
#import "OWLObjectMaxCardinalityImpl.h"
#import "OWLObjectMinCardinalityImpl.h"
#import "OWLObjectPropertyExpression.h"
#import "OWLObjectSomeValuesFromImpl.h"
#import "OWLOntologyBuilder.h"
#import "OWLPropertyBuilder.h"
#import "OWLRDFVocabulary.h"
#import "NSString+SMRStringUtils.h"

@interface OWLClassExpressionBuilder ()

@property (nonatomic, weak, readonly) OWLOntologyBuilder *ontologyBuilder;

@end


@implementation OWLClassExpressionBuilder

@synthesize ontologyBuilder = _ontologyBuilder;

#pragma mark Lifecycle

- (instancetype)initWithOntologyBuilder:(OWLOntologyBuilder *)ontologyBuilder
{
    NSParameterAssert(ontologyBuilder);
    
    if ((self = [super init])) {
        _ontologyBuilder = ontologyBuilder;
        _type = OWLCEBTypeUnknown;
        _restrictionType = OWLCEBRestrictionTypeUnknown;
    }
    return self;
}

#pragma mark OWLAbstractBuilder

- (id<OWLClassExpression>)build
{
    id<OWLClassExpression> builtClassExpression = nil;
    
    switch(self.type)
    {
        case OWLCEBTypeClass:
            builtClassExpression = [self buildClassExpression];
            break;
            
        case OWLCEBTypeRestriction:
            builtClassExpression = [self buildRestriction];
            break;
            
        default:
            break;
    }
    
    return builtClassExpression;
}

- (id<OWLClassExpression>)buildClassExpression
{
    id<OWLClassExpression> classExpression = nil;
    NSString *classID = self.classID;
    
    if (classID) {
        // Named class
        NSURL *IRI = [[NSURL alloc] initWithString:classID];
        if (IRI) {
            classExpression = [[OWLClassImpl alloc] initWithIRI:IRI];
        }
    } else {
        OWLCEBBooleanType type = self.booleanType;
        NSString *listID = self.listID;
        
        if (type != OWLCEBBooleanTypeUnknown && listID) {
            // Boolean class expression
            switch (type)
            {
                case OWLCEBBooleanTypeIntersection:
                {
                    NSMutableSet *operands = [[NSMutableSet alloc] init];
                    OWLOntologyBuilder *ontologyBuilder = self.ontologyBuilder;
                    
                    for (NSString *ID in [ontologyBuilder firstItemsForListID:listID]) {
                        id<OWLClassExpression> ce = [[ontologyBuilder classExpressionBuilderForID:ID] build];
                        if (ce) {
                            [operands addObject:ce];
                        }
                    }
                    
                    classExpression = [[OWLObjectIntersectionOfImpl alloc] initWithOperands:operands];
                    break;
                }
                    
                default:
                    break;
            }
        }
    }
    
    return classExpression;
}

- (id<OWLRestriction>)buildRestriction
{
    OWLCEBRestrictionType type = self.restrictionType;
    NSString *propertyID = self.propertyID;
    
    if (type == OWLCEBRestrictionTypeUnknown || !propertyID) {
        return nil;
    }
    
    id<OWLRestriction> restr = nil;
    OWLOntologyBuilder *ontologyBuilder = self.ontologyBuilder;
    
    id<OWLPropertyExpression> property = [[ontologyBuilder propertyBuilderForID:propertyID] build];
    
    NSString *fillerID = self.fillerID;
    id<OWLClassExpression> filler = nil;
    if (fillerID) {
        filler = [[ontologyBuilder classExpressionBuilderForID:fillerID] build];
    }
    
    // TODO: currently only supports object properties
    if (property && [property isObjectPropertyExpression]) {
        id<OWLObjectPropertyExpression> objectPropertyExpr = (id<OWLObjectPropertyExpression>)property;
        
        switch (type)
        {
            case OWLCEBRestrictionTypeSomeValuesFrom:
                if (filler) {
                    restr = [[OWLObjectSomeValuesFromImpl alloc] initWithProperty:objectPropertyExpr filler:filler];
                }
                break;
                
            case OWLCEBRestrictionTypeAllValuesFrom:
                if (filler) {
                    restr = [[OWLObjectAllValuesFromImpl alloc] initWithProperty:objectPropertyExpr filler:filler];
                }
                break;
                
            case OWLCEBRestrictionTypeCardinality:
                restr = [self buildCardinalityRestrictionOfClass:[OWLObjectExactCardinalityImpl class]
                                                 withCardinality:self.cardinality
                                                        property:objectPropertyExpr
                                                          filler:filler];
                break;
                
            case OWLCEBRestrictionTypeMaxCardinality:
                restr = [self buildCardinalityRestrictionOfClass:[OWLObjectMaxCardinalityImpl class]
                                                 withCardinality:self.cardinality
                                                        property:objectPropertyExpr
                                                          filler:filler];
                break;
                
            case OWLCEBRestrictionTypeMinCardinality:
                restr = [self buildCardinalityRestrictionOfClass:[OWLObjectMinCardinalityImpl class]
                                                 withCardinality:self.cardinality
                                                        property:objectPropertyExpr
                                                          filler:filler];
                break;
                
            default:
                break;
        }
    }
    
    return restr;
}

- (id<OWLRestriction>)buildCardinalityRestrictionOfClass:(Class)cls
                                         withCardinality:(NSString *)cardString
                                                property:(id<OWLObjectPropertyExpression>)property
                                                  filler:(id<OWLClassExpression>)filler
{
    NSInteger cardinality;
    id restr = nil;
    
    if ([cardString smr_hasIntegerValue:&cardinality] && cardinality >= 0) {
        
        if (!filler) {
            filler = [[OWLClassImpl alloc] initWithIRI:[OWLRDFVocabulary OWLThing].IRI];
        }
        
        restr = [(OWLObjectCardinalityRestrictionImpl *)[cls alloc] initWithProperty:property
                                                                              filler:filler
                                                                         cardinality:(NSUInteger)cardinality];
    }
    
    return restr;
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

#pragma mark Boolean

// booleanType
@synthesize booleanType = _booleanType;

- (BOOL)setBooleanType:(OWLCEBBooleanType)type error:(NSError *__autoreleasing  _Nullable *)error
{
    if (_booleanType == type) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (_booleanType == OWLCEBBooleanTypeUnknown) {
        _booleanType = type;
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple boolean types for class expression."
                                  userInfo:@{@"types": @[@(_booleanType), @(type)]}];
    }
    
    return success;
}

// listID
@synthesize listID = _listID;

- (BOOL)setListID:(NSString *)ID error:(NSError *__autoreleasing  _Nullable *)error
{
    if (_listID == ID || [_listID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_listID) {
        _listID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple list IDs for boolean class expression."
                                  userInfo:@{@"IDs": @[_listID, ID]}];
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

#pragma mark SomeValuesFrom/AllValuesFrom

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

#pragma mark Cardinality

// cardinality
@synthesize cardinality = _cardinality;

- (BOOL)setCardinality:(NSString *)cardinality error:(NSError *__autoreleasing *)error
{
    if (_cardinality == cardinality || [_cardinality isEqualToString:cardinality]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_cardinality) {
        _cardinality = [cardinality copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple cardinalities for restriction."
                                  userInfo:@{@"cardinalities": @[_cardinality, cardinality]}];
    }
    
    return success;
}

@end
