//
//  OWLAxiomBuilder.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAxiomBuilder.h"
#import "OWLClassAssertionAxiomImpl.h"
#import "OWLClassExpression.h"
#import "OWLClassExpressionBuilder.h"
#import "OWLDeclarationAxiomImpl.h"
#import "OWLDisjointClassesAxiomImpl.h"
#import "OWLEquivalentClassesAxiomImpl.h"
#import "OWLError.h"
#import "OWLIndividual.h"
#import "OWLIndividualBuilder.h"
#import "OWLNamedIndividual.h"
#import "OWLObjectPropertyAssertionAxiomImpl.h"
#import "OWLObjectPropertyDomainAxiomImpl.h"
#import "OWLObjectPropertyRangeAxiomImpl.h"
#import "OWLOntologyBuilder.h"
#import "OWLPropertyBuilder.h"
#import "OWLSubClassOfAxiomImpl.h"

@interface OWLAxiomBuilder ()
{
    __weak OWLOntologyBuilder *_ontologyBuilder;
    id<OWLAxiom> _builtAxiom;
}
@end


@implementation OWLAxiomBuilder

#pragma mark Lifecycle

- (instancetype)initWithOntologyBuilder:(OWLOntologyBuilder *)builder
{
    NSParameterAssert(builder);
    
    if ((self = [super init])) {
        _ontologyBuilder = builder;
        _type = OWLABTypeUnknown;
    }
    return self;
}

#pragma mark OWLAbstractBuilder

- (id<OWLAxiom>)build
{
    if (_builtAxiom) {
        return _builtAxiom;
    }
    
    id<OWLAxiom> builtAxiom = nil;
    
    switch (_type)
    {
        case OWLABTypeDeclaration: {
            NSString *entityID = _LHSID;
            
            if (entityID) {
                id<OWLEntity> entity = [[_ontologyBuilder entityBuilderForID:entityID] build];
                
                if (entity) {
                    builtAxiom = [[OWLDeclarationAxiomImpl alloc] initWithEntity:entity];
                }
            }
            
            break;
        }
            
        case OWLABTypeClassAssertion: {
            NSString *individualID = _LHSID;
            NSString *classID = _RHSID;
            
            if (individualID && classID) {
                OWLOntologyBuilder *ontoBuilder = _ontologyBuilder;
                
                id<OWLIndividual> individual = [[ontoBuilder individualBuilderForID:individualID] build];
                id<OWLClassExpression> class = [[ontoBuilder classExpressionBuilderForID:classID] build];
                
                if (individual && class) {
                    builtAxiom = [[OWLClassAssertionAxiomImpl alloc] initWithIndividual:individual classExpression:class];
                }
            }
            break;
        }
            
        case OWLABTypePropertyAssertion: {
            NSString *subjectID = _LHSID;
            NSString *propertyID = _MID;
            NSString *objectID = _RHSID;
            
            if (subjectID && propertyID && objectID) {
                OWLOntologyBuilder *ontoBuilder = _ontologyBuilder;
                
                id<OWLIndividual> subject = [[ontoBuilder individualBuilderForID:subjectID] build];
                id<OWLPropertyExpression> property = [[ontoBuilder propertyBuilderForID:propertyID] build];
                
                // TODO: only supports object property assertion axioms
                if (subject && property.isObjectPropertyExpression) {
                    id<OWLObjectPropertyExpression> objProp = (id<OWLObjectPropertyExpression>)property;
                    id<OWLIndividual> object = [[ontoBuilder individualBuilderForID:objectID] build];
                    
                    if (object) {
                        builtAxiom = [[OWLObjectPropertyAssertionAxiomImpl alloc] initWithSubject:subject property:objProp object:object];
                    }
                }
            }
            break;
        }
            
        case OWLABTypeDisjointClasses:
            builtAxiom = [self buildBinaryClassExpressionAxiomWithInitBlock:
                          ^id<OWLAxiom>(id<OWLClassExpression> LHS, id<OWLClassExpression> RHS) {
                              return [[OWLDisjointClassesAxiomImpl alloc] initWithClassExpressions:[NSSet setWithObjects:LHS, RHS, nil]];
                          }];
            break;
            
        case OWLABTypeEquivalentClasses:
            builtAxiom = [self buildBinaryClassExpressionAxiomWithInitBlock:
                          ^id<OWLAxiom>(id<OWLClassExpression> LHS, id<OWLClassExpression> RHS) {
                              return [[OWLEquivalentClassesAxiomImpl alloc] initWithClassExpressions:[NSSet setWithObjects:LHS, RHS, nil]];
                          }];
            break;
            
        case OWLABTypeSubClassOf:
            builtAxiom = [self buildBinaryClassExpressionAxiomWithInitBlock:
                          ^id<OWLAxiom>(id<OWLClassExpression> LHS, id<OWLClassExpression> RHS) {
                              return [[OWLSubClassOfAxiomImpl alloc] initWithSuperClass:RHS subClass:LHS];
                          }];
            break;
            
        case OWLABTypeDomain:
            builtAxiom = [self buildDomainRangeAxiomWithInitBlock:
                          ^id<OWLAxiom>(id<OWLObjectPropertyExpression> OPE, id<OWLClassExpression> CE) {
                              return [[OWLObjectPropertyDomainAxiomImpl alloc] initWithProperty:OPE domain:CE];
                          }];
            break;
            
        case OWLABTypeRange:
            builtAxiom = [self buildDomainRangeAxiomWithInitBlock:
                          ^id<OWLAxiom>(id<OWLObjectPropertyExpression> OPE, id<OWLClassExpression> CE) {
                              return [[OWLObjectPropertyRangeAxiomImpl alloc] initWithProperty:OPE range:CE];
                          }];
            break;
            
        default:
            break;
    }
    
    if (builtAxiom) {
        _builtAxiom = builtAxiom;
        _LHSID = nil;
        _MID = nil;
        _RHSID = nil;
    }
    return builtAxiom;
}

- (id<OWLAxiom>)buildBinaryClassExpressionAxiomWithInitBlock:(id<OWLAxiom>(^)(id<OWLClassExpression>LHS, id<OWLClassExpression>RHS))block
{
    id<OWLAxiom> builtAxiom = nil;
    
    NSString *RHSClassID = _RHSID;
    NSString *LHSClassID = _LHSID;
    
    if (RHSClassID && LHSClassID) {
        OWLOntologyBuilder *ontoBuilder = _ontologyBuilder;
        
        id<OWLClassExpression> RHSClassExpression = [[ontoBuilder classExpressionBuilderForID:RHSClassID] build];
        id<OWLClassExpression> LHSClassExpression = [[ontoBuilder classExpressionBuilderForID:LHSClassID] build];
        
        if (RHSClassExpression && LHSClassExpression) {
            builtAxiom = block(LHSClassExpression, RHSClassExpression);
        }
    }
    
    return builtAxiom;
}

- (id<OWLAxiom>)buildDomainRangeAxiomWithInitBlock:(id<OWLAxiom>(^)(id<OWLObjectPropertyExpression>OPE, id<OWLClassExpression>CE))block
{
    id<OWLAxiom> builtAxiom = nil;
    
    NSString *propertyID = _LHSID;
    NSString *domainRangeID = _RHSID;
    
    if (propertyID && domainRangeID) {
        OWLOntologyBuilder *ontoBuilder = _ontologyBuilder;
        
        id<OWLPropertyExpression> propertyExpr = [[ontoBuilder propertyBuilderForID:propertyID] build];
        
        // TODO: only supports object property expressions
        if (propertyExpr.isObjectPropertyExpression) {
            id<OWLObjectPropertyExpression> objPropExpr = (id<OWLObjectPropertyExpression>)propertyExpr;
            
            id<OWLClassExpression> domainRangeCE = [[ontoBuilder classExpressionBuilderForID:domainRangeID] build];
            if (domainRangeCE) {
                builtAxiom = block(objPropExpr, domainRangeCE);
            }
        }
    }
    
    return builtAxiom;
}

#pragma mark General

// type
@synthesize type = _type;

- (BOOL)setType:(OWLABType)type error:(NSError *__autoreleasing *)error
{
    if (_type == type) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (_type == OWLABTypeUnknown) {
        _type = type;
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple axiom types for same axiom."
                                  userInfo:@{@"types": @[@(_type), @(type)]}];
    }
    
    return success;
}

#pragma mark Single statement axioms

// LHSID
@synthesize LHSID = _LHSID;

- (BOOL)setLHSID:(NSString *)ID error:(NSError *__autoreleasing *)error
{
    if (_LHSID == ID || [_LHSID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_LHSID) {
        _LHSID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple left-hand-side IDs for same axiom."
                                  userInfo:@{@"IDs": @[_LHSID, ID]}];
    }
    
    return success;
}

// MID
@synthesize MID = _MID;

- (BOOL)setMID:(NSString *)ID error:(NSError *__autoreleasing *)error
{
    if (_MID == ID || [_MID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_MID) {
        _MID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple middle IDs for same axiom."
                                  userInfo:@{@"IDs": @[_MID, ID]}];
    }
    
    return success;
}

// RHSID
@synthesize RHSID = _RHSID;

- (BOOL)setRHSID:(NSString *)ID error:(NSError *__autoreleasing *)error
{
    if (_RHSID == ID || [_RHSID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_RHSID) {
        _RHSID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple right-hand-side IDs for same axiom."
                                  userInfo:@{@"IDs": @[_RHSID, ID]}];
    }
    
    return success;
}

@end
