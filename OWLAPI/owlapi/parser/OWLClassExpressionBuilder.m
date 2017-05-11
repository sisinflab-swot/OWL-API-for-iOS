//
//  Created by Ivano Bilenchi on 16/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClassExpressionBuilder.h"
#import "OWLClassImpl.h"
#import "OWLError.h"
#import "OWLIRI.h"
#import "OWLObjectAllValuesFromImpl.h"
#import "OWLObjectComplementOfImpl.h"
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
{
    __weak OWLOntologyBuilder *_ontologyBuilder;
    id<OWLClassExpression> _builtClassExpression;
}
@end


@implementation OWLClassExpressionBuilder

#pragma mark Lifecycle

- (instancetype)initWithOntologyBuilder:(OWLOntologyBuilder *)ontologyBuilder
{
    NSParameterAssert(ontologyBuilder);
    
    if ((self = [super init]))
    {
        _ontologyBuilder = ontologyBuilder;
        _type = OWLCEBTypeUnknown;
        _restrictionType = OWLCEBRestrictionTypeUnknown;
    }
    return self;
}

- (void)dealloc
{
    [self free];
}

- (void)free
{
    _IRI = nil;
    _cardinality = nil;
    
    free(_operandID);
    _operandID = NULL;
    
    free(_listID);
    _listID = NULL;
    
    free(_fillerID);
    _fillerID = NULL;
    
    free(_propertyID);
    _propertyID = NULL;
}

#pragma mark OWLAbstractBuilder

- (id<OWLClassExpression>)build
{
    if (_builtClassExpression) {
        return _builtClassExpression;
    }
    
    id<OWLClassExpression> builtClassExpression = nil;
    
    switch(_type)
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
    
    if (builtClassExpression) {
        _builtClassExpression = builtClassExpression;
        [self free];
    }
    
    return builtClassExpression;
}

- (id<OWLClassExpression>)buildClassExpression
{
    id<OWLClassExpression> classExpression = nil;
    
    if (_IRI) {
        // Named class
        OWLIRI *IRI = [[OWLIRI alloc] initWithString:(NSString *_Nonnull)_IRI];
        classExpression = [[OWLClassImpl alloc] initWithIRI:IRI];
    } else {
        OWLCEBBooleanType type = _booleanType;
        
        if (type != OWLCEBBooleanTypeUnknown) {
            // Boolean class expression
            switch (type)
            {
                case OWLCEBBooleanTypeComplement: {
                    OWLOntologyBuilder *ontologyBuilder = _ontologyBuilder;
                    unsigned char *operandID = _operandID;
                    
                    if (operandID) {
                        id<OWLClassExpression> operand = [[ontologyBuilder classExpressionBuilderForID:operandID] build];
                        classExpression = [[OWLObjectComplementOfImpl alloc] initWithOperand:operand];
                    }
                    
                }
                case OWLCEBBooleanTypeIntersection: {
                    NSMutableSet *operands = [[NSMutableSet alloc] init];
                    OWLOntologyBuilder *ontologyBuilder = _ontologyBuilder;
                    unsigned char *listID = _listID;
                    
                    if (listID) {
                        [ontologyBuilder iterateFirstItemsForListID:listID withHandler:^(unsigned char * _Nonnull firstID) {
                            id<OWLClassExpression> ce = [[ontologyBuilder classExpressionBuilderForID:firstID] build];
                            if (ce) {
                                [operands addObject:ce];
                            }
                        }];
                        
                        classExpression = [[OWLObjectIntersectionOfImpl alloc] initWithOperands:operands];
                    }
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
    OWLCEBRestrictionType type = _restrictionType;
    unsigned char *propertyID = _propertyID;
    
    if (type == OWLCEBRestrictionTypeUnknown || !propertyID) {
        return nil;
    }
    
    id<OWLRestriction> restr = nil;
    OWLOntologyBuilder *ontologyBuilder = _ontologyBuilder;
    id<OWLPropertyExpression> property = [[ontologyBuilder propertyBuilderForID:propertyID] build];
    
    unsigned char *fillerID = _fillerID;
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
                                                 withCardinality:_cardinality
                                                        property:objectPropertyExpr
                                                          filler:filler];
                break;
                
            case OWLCEBRestrictionTypeMaxCardinality:
                restr = [self buildCardinalityRestrictionOfClass:[OWLObjectMaxCardinalityImpl class]
                                                 withCardinality:_cardinality
                                                        property:objectPropertyExpr
                                                          filler:filler];
                break;
                
            case OWLCEBRestrictionTypeMinCardinality:
                restr = [self buildCardinalityRestrictionOfClass:[OWLObjectMinCardinalityImpl class]
                                                 withCardinality:_cardinality
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

SYNTHESIZE_BUILDER_VALUE_PROPERTY(OWLCEBType, type, Type, @"Multiple types for class expression.")


#pragma mark Class

SYNTHESIZE_BUILDER_STRING_PROPERTY(IRI, IRI, @"Multiple IRIs for class.")


#pragma mark Boolean

SYNTHESIZE_BUILDER_VALUE_PROPERTY(OWLCEBBooleanType, booleanType, BooleanType, @"Multiple boolean types for class expression.")
SYNTHESIZE_BUILDER_CSTRING_PROPERTY(operandID, OperandID, @"Multiple operand IDs for complement boolean class expression.")
SYNTHESIZE_BUILDER_CSTRING_PROPERTY(listID, ListID, @"Multiple list IDs for boolean class expression.")


#pragma mark Restriction

SYNTHESIZE_BUILDER_VALUE_PROPERTY(OWLCEBRestrictionType, restrictionType, RestrictionType, @"Multiple types for restriction.")
SYNTHESIZE_BUILDER_CSTRING_PROPERTY(propertyID, PropertyID, @"Multiple 'onProperty' statements for restriction.")


#pragma mark SomeValuesFrom/AllValuesFrom

SYNTHESIZE_BUILDER_CSTRING_PROPERTY(fillerID, FillerID, @"Multiple fillers for restriction.")


#pragma mark Cardinality

SYNTHESIZE_BUILDER_STRING_PROPERTY(cardinality, Cardinality, @"Multiple cardinalities for restriction.")


@end
