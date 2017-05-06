//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAxiomBuilder.h"
#import "OWLClass.h"
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
#import "OWLObjectProperty.h"
#import "OWLObjectPropertyAssertionAxiomImpl.h"
#import "OWLObjectPropertyDomainAxiomImpl.h"
#import "OWLObjectPropertyRangeAxiomImpl.h"
#import "OWLOntologyBuilder.h"
#import "OWLPropertyBuilder.h"
#import "OWLSubClassOfAxiomImpl.h"
#import "OWLTransitiveObjectPropertyAxiomImpl.h"

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
            OWLOntologyBuilder *ontoBuilder = _ontologyBuilder;
            NSString *entityID = _LHSID;
            id<OWLEntity> entity = nil;
            
            switch (_declType)
            {
                case OWLABDeclTypeClass: {
                    id<OWLClassExpression> ce = [[ontoBuilder classExpressionBuilderForID:entityID] build];
                    entity = [ce asOwlClass];
                    break;
                }
                    
                case OWLABDeclTypeObjectProperty: {
                    id<OWLPropertyExpression> pe = [[ontoBuilder propertyBuilderForID:entityID] build];
                    if ([pe isObjectPropertyExpression]) {
                        entity = [(id<OWLObjectPropertyExpression>)pe asOWLObjectProperty];
                    }
                    break;
                }
                    
                case OWLABDeclTypeNamedIndividual: {
                    id<OWLIndividual> ind = [[ontoBuilder individualBuilderForID:entityID] build];
                    if (ind.named) {
                        entity = (id<OWLNamedIndividual>)ind;
                    }
                    break;
                }
                    
                default:
                    break;
            }
            
            if (entity) {
                builtAxiom = [[OWLDeclarationAxiomImpl alloc] initWithEntity:entity];
            }
            
            break;
        }
            
        case OWLABTypeClassAssertion: {
            OWLOntologyBuilder *ontoBuilder = _ontologyBuilder;
            
            NSString *individualID = _LHSID;
            NSString *classID = _RHSID;
            
            if (individualID && classID) {
                id<OWLIndividual> individual = [[ontoBuilder individualBuilderForID:individualID] build];
                id<OWLClassExpression> class = [[ontoBuilder classExpressionBuilderForID:classID] build];
                
                if (individual && class) {
                    builtAxiom = [[OWLClassAssertionAxiomImpl alloc] initWithIndividual:individual classExpression:class];
                }
            }
            break;
        }
            
        case OWLABTypePropertyAssertion: {
            OWLOntologyBuilder *ontoBuilder = _ontologyBuilder;
            
            NSString *subjectID = _LHSID;
            NSString *propertyID = _MID;
            NSString *objectID = _RHSID;
            
            if (subjectID && propertyID && objectID) {
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
            
        case OWLABTypeTransitiveProperty: {
            OWLOntologyBuilder *ontoBuilder = _ontologyBuilder;
            NSString *propertyID = _LHSID;
            
            if (propertyID) {
                id<OWLPropertyExpression> property = [[ontoBuilder propertyBuilderForID:propertyID] build];
                if (property && property.isObjectPropertyExpression) {
                    id<OWLObjectPropertyExpression> objProp = (id<OWLObjectPropertyExpression>)property;
                    builtAxiom = [[OWLTransitiveObjectPropertyAxiomImpl alloc] initWithProperty:objProp];
                }
            }
            break;
        }
            
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

SYNTHESIZE_BUILDER_VALUE_PROPERTY(OWLABType, type, Type, @"Multiple axiom types for same axiom.")


#pragma mark Declaration

SYNTHESIZE_BUILDER_VALUE_PROPERTY(OWLABDeclType, declType, DeclType, @"Multiple declaration axiom types for same axiom.")


#pragma mark Single statement axioms

SYNTHESIZE_BUILDER_STRING_PROPERTY(LHSID, LHSID, @"Multiple left-hand-side IDs for same axiom.")
SYNTHESIZE_BUILDER_STRING_PROPERTY(MID, MID, @"Multiple middle IDs for same axiom.")
SYNTHESIZE_BUILDER_STRING_PROPERTY(RHSID, RHSID, @"Multiple right-hand-side IDs for same axiom.")

@end
