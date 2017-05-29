//
//  Created by Ivano Bilenchi on 23/05/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import "OWLDLExpressivityChecker.h"
#import "OWLAxiom.h"
#import "OWLClassAssertionAxiom.h"
#import "OWLClassExpression.h"
#import "OWLDisjointClassesAxiom.h"
#import "OWLEquivalentClassesAxiom.h"
#import "OWLObjCUtils.h"
#import "OWLObjectAllValuesFrom.h"
#import "OWLObjectCardinalityRestriction.h"
#import "OWLObjectComplementOf.h"
#import "OWLObjectIntersectionOf.h"
#import "OWLObjectPropertyAssertionAxiom.h"
#import "OWLObjectPropertyDomainAxiom.h"
#import "OWLObjectPropertyRangeAxiom.h"
#import "OWLObjectSomeValuesFrom.h"
#import "OWLSubClassOfAxiom.h"
#import "OWLTransitiveObjectPropertyAxiom.h"

@implementation OWLDLExpressivityChecker

#define has_construct(CONSTRUCT) has_option(_constructs, OWLDLConstruct##CONSTRUCT)
#define add_construct(CONSTRUCT) (_constructs |= OWLDLConstruct##CONSTRUCT)
#define remove_construct(CONSTRUCT) (_constructs = _constructs & ~OWLDLConstruct##CONSTRUCT)

#pragma mark - Properties

@synthesize constructs = _constructs;

#pragma mark - Public methods

- (NSString *)descriptionLogicName
{
    static OWLDLConstruct order[] = {
        OWLDLConstructS,
        OWLDLConstructAL,
        OWLDLConstructC,
        OWLDLConstructU,
        OWLDLConstructE,
        OWLDLConstructR,
        OWLDLConstructH,
        OWLDLConstructO,
        OWLDLConstructI,
        OWLDLConstructN,
        OWLDLConstructQ,
        OWLDLConstructF,
        OWLDLConstructTRAN,
        OWLDLConstructD
    };
    
    [self pruneConstructs];
    NSMutableString *name = [[NSMutableString alloc] init];
    
    for (unsigned i = 0; i < sizeof(order) / sizeof(*order); ++i) {
        OWLDLConstruct construct = order[i];
        
        if (has_option(_constructs, construct)) {
            [name appendString:[self nameForConstruct:construct]];
        }
    }
    
    return name;
}

- (NSString *)nameForConstruct:(OWLDLConstruct)construct
{
    switch (construct) {
        case OWLDLConstructAL:
            return @"AL";
        case OWLDLConstructEL:
            return @"EL";
        case OWLDLConstructU:
            return @"U";
        case OWLDLConstructC:
            return @"C";
        case OWLDLConstructE:
            return @"E";
        case OWLDLConstructN:
            return @"N";
        case OWLDLConstructQ:
            return @"Q";
        case OWLDLConstructH:
            return @"H";
        case OWLDLConstructI:
            return @"I";
        case OWLDLConstructO:
            return @"O";
        case OWLDLConstructF:
            return @"F";
        case OWLDLConstructTRAN:
            return @"+";
        case OWLDLConstructD:
            return @"D";
        case OWLDLConstructR:
            return @"R";
        case OWLDLConstructS:
            return @"S";
        case OWLDLConstructELPLUSPLUS:
            return @"EL++";
        default:
            return @"";
    }
}

- (void)pruneConstructs
{
    if (has_construct(AL)) {
        if (has_construct(C)) {
            remove_construct(E);
            remove_construct(U);
        } else if (has_construct(E) && has_construct(U)) {
            add_construct(AL);
            add_construct(C);
            remove_construct(E);
            remove_construct(U);
        }
    }
    
    if (has_construct(N) || has_construct(Q)) {
        remove_construct(F);
    }
    
    if (has_construct(Q)) {
        remove_construct(N);
    }
    
    if (has_construct(AL) && has_construct(C) && has_construct(TRAN)) {
        remove_construct(AL);
        remove_construct(C);
        remove_construct(TRAN);
        add_construct(S);
    }
    
    if (has_construct(R)) {
        remove_construct(H);
    }
}

- (void)addConstructsForAxiom:(id<OWLAxiom>)axiom recursive:(BOOL)recursive
{
    switch (axiom.axiomType) {
        case OWLAxiomTypeSubClassOf: {
            if (recursive) {
                id<OWLSubClassOfAxiom> sub = (id<OWLSubClassOfAxiom>)axiom;
                [self addConstructsForClassExpression:sub.superClass recursive:YES];
                [self addConstructsForClassExpression:sub.subClass recursive:YES];
            }
            break;
        }
        case OWLAxiomTypeDisjointClasses: {
            add_construct(C);
            if (recursive) {
                for (id<OWLClassExpression> exp in [(id<OWLDisjointClassesAxiom>)axiom classExpressions]) {
                    [self addConstructsForClassExpression:exp recursive:YES];
                }
            }
            break;
        }
        case OWLAxiomTypeObjectPropertyDomain: {
            add_construct(AL);
            if (recursive) {
                id<OWLObjectPropertyDomainAxiom> da = (id<OWLObjectPropertyDomainAxiom>)axiom;
                [self addConstructsForClassExpression:da.domain recursive:YES];
                [self addConstructsForPropertyExpression:da.property];
            }
            break;
        }
        case OWLAxiomTypeObjectPropertyRange: {
            add_construct(AL);
            if (recursive) {
                id<OWLObjectPropertyRangeAxiom> ra = (id<OWLObjectPropertyRangeAxiom>)axiom;
                [self addConstructsForClassExpression:ra.range recursive:YES];
                [self addConstructsForPropertyExpression:ra.property];
            }
            break;
        }
        case OWLAxiomTypeObjectPropertyAssertion: {
            if (recursive) {
                [self addConstructsForPropertyExpression:[(id<OWLObjectPropertyAssertionAxiom>)axiom property]];
            }
            break;
        }
        case OWLAxiomTypeClassAssertion: {
            if (recursive) {
                [self addConstructsForClassExpression:[(id<OWLClassAssertionAxiom>) axiom classExpression] recursive:YES];
            }
            break;
        }
        case OWLAxiomTypeEquivalentClasses: {
            if (recursive) {
                for (id<OWLClassExpression> exp in [(id<OWLEquivalentClassesAxiom>)axiom classExpressions]) {
                    [self addConstructsForClassExpression:exp recursive:YES];
                }
            }
            break;
        }
        case OWLAxiomTypeTransitiveObjectProperty: {
            add_construct(TRAN);
            if (recursive) {
                [self addConstructsForPropertyExpression:[(id<OWLTransitiveObjectPropertyAxiom>)axiom property]];
            }
            break;
        }
        case OWLAxiomTypeNegativeObjectPropertyAssertion:
        case OWLAxiomTypeAsymmetricObjectProperty:
        case OWLAxiomTypeReflexiveObjectProperty:
        case OWLAxiomTypeDataPropertyDomain:
        case OWLAxiomTypeEquivalentObjectProperties:
        case OWLAxiomTypeNegativeDataPropertyAssertion:
        case OWLAxiomTypeDifferentIndividuals:
        case OWLAxiomTypeDisjointDataProperties:
        case OWLAxiomTypeDisjointObjectProperties:
        case OWLAxiomTypeFunctionalObjectProperty:
        case OWLAxiomTypeSubObjectPropertyOf:
        case OWLAxiomTypeDisjointUnion:
        case OWLAxiomTypeSymmetricObjectProperty:
        case OWLAxiomTypeDataPropertyRange:
        case OWLAxiomTypeFunctionalDataProperty:
        case OWLAxiomTypeEquivalentDataProperties:
        case OWLAxiomTypeDataPropertyAssertion:
        case OWLAxiomTypeIrreflexiveObjectProperty:
        case OWLAxiomTypeSubDataPropertyOf:
        case OWLAxiomTypeInverseFunctionalObjectProperty:
        case OWLAxiomTypeSameIndividual:
        case OWLAxiomTypeSubPropertyChainOf:
        case OWLAxiomTypeInverseObjectProperties:
        {
            // TODO
            break;
        }
        default: {
            break;
        }
    }
}

- (void)addConstructsForClassExpression:(id<OWLClassExpression>)ce recursive:(BOOL)recursive
{
    switch (ce.classExpressionType) {
        case OWLClassExpressionTypeObjectIntersectionOf: {
            add_construct(AL);
            if (recursive) {
                for (id<OWLClassExpression> exp in [(id<OWLObjectIntersectionOf>)ce operands]) {
                    [self addConstructsForClassExpression:exp recursive:YES];
                }
            }
            break;
        }
        case OWLClassExpressionTypeObjectComplementOf: {
            // TODO: must be edited when support for imports is added
            ce.anonymous ? add_construct(C) : add_construct(AL);
            if (recursive) {
                [self addConstructsForClassExpression:[(id<OWLObjectComplementOf>)ce operand] recursive:YES];
            }
            break;
        }
        case OWLClassExpressionTypeObjectSomeValuesFrom: {
            ce.isOWLThing ? add_construct(AL) : add_construct(E);
            if (recursive) {
                id<OWLObjectSomeValuesFrom> svf = (id<OWLObjectSomeValuesFrom>)ce;
                [self addConstructsForPropertyExpression:svf.property];
                [self addConstructsForClassExpression:svf.filler recursive:YES];
            }
            break;
        }
        case OWLClassExpressionTypeObjectAllValuesFrom: {
            add_construct(AL);
            if (recursive) {
                id<OWLObjectAllValuesFrom> avf = (id<OWLObjectAllValuesFrom>)ce;
                [self addConstructsForPropertyExpression:avf.property];
                [self addConstructsForClassExpression:avf.filler recursive:YES];
            }
            break;
        }
        case OWLClassExpressionTypeObjectMinCardinality:
        case OWLClassExpressionTypeObjectExactCardinality:
        case OWLClassExpressionTypeObjectMaxCardinality: {
            id<OWLObjectCardinalityRestriction> restr = (id<OWLObjectCardinalityRestriction>)ce;
            restr.qualified ? add_construct(Q) : add_construct(N);
            if (recursive) {
                [self addConstructsForPropertyExpression:restr.property];
                [self addConstructsForClassExpression:restr.filler recursive:YES];
            }
            break;
        }
        case OWLClassExpressionTypeObjectUnionOf:
        case OWLClassExpressionTypeObjectHasValue:
        case OWLClassExpressionTypeObjectHasSelf:
        case OWLClassExpressionTypeObjectOneOf:
        case OWLClassExpressionTypeDataSomeValuesFrom:
        case OWLClassExpressionTypeDataAllValuesFrom:
        case OWLClassExpressionTypeDataHasValue:
        case OWLClassExpressionTypeDataMinCardinality:
        case OWLClassExpressionTypeDataExactCardinality:
        case OWLClassExpressionTypeDataMaxCardinality: {
            // TODO
            break;
        }
        default: {
            break;
        }
    }
}

- (void)addConstructsForPropertyExpression:(id<OWLPropertyExpression>)pe
{
    // TODO: stub implementation
    if (pe.isDataPropertyExpression) {
        add_construct(D);
    }
}

@end
