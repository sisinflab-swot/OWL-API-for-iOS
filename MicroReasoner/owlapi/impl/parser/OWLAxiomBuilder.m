//
//  OWLAxiomBuilder.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAxiomBuilder.h"
#import "OWLClassExpression.h"
#import "OWLClassExpressionBuilder.h"
#import "OWLDeclarationAxiomImpl.h"
#import "OWLDisjointClassesAxiomImpl.h"
#import "OWLEquivalentClassesAxiomImpl.h"
#import "OWLError.h"
#import "OWLOntologyBuilder.h"
#import "OWLSubClassOfAxiomImpl.h"

@interface OWLAxiomBuilder ()

@property (nonatomic, strong) id<OWLAxiom> builtAxiom;
@property (nonatomic, weak, readonly) OWLOntologyBuilder *ontologyBuilder;

@end


@implementation OWLAxiomBuilder

@synthesize builtAxiom = _builtAxiom;
@synthesize ontologyBuilder = _ontologyBuilder;

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
    id<OWLAxiom> builtAxiom = self.builtAxiom;
    
    if (builtAxiom) {
        return builtAxiom;
    }
    
    switch (self.type)
    {
        case OWLABTypeDeclaration: {
            NSString *entityID = self.entityID;
            
            if (entityID) {
                id<OWLEntity> entity = [[self.ontologyBuilder entityBuilderForID:entityID] build];
                
                if (entity) {
                    builtAxiom = [[OWLDeclarationAxiomImpl alloc] initWithEntity:entity];
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
            
        default:
            break;
    }
    
    self.builtAxiom = builtAxiom;
    return builtAxiom;
}

- (id<OWLAxiom>)buildBinaryClassExpressionAxiomWithInitBlock:(id<OWLAxiom>(^)(id<OWLClassExpression>LHS, id<OWLClassExpression>RHS))block
{
    id<OWLAxiom> builtAxiom = nil;
    
    NSString *RHSClassID = self.RHSClassID;
    NSString *LHSClassID = self.LHSClassID;
    
    if (RHSClassID && LHSClassID) {
        OWLOntologyBuilder *ontoBuilder = self.ontologyBuilder;
        
        id<OWLClassExpression> RHSClassExpression = [[ontoBuilder classExpressionBuilderForID:RHSClassID] build];
        id<OWLClassExpression> LHSClassExpression = [[ontoBuilder classExpressionBuilderForID:LHSClassID] build];
        
        if (RHSClassExpression && LHSClassExpression) {
            builtAxiom = block(LHSClassExpression, RHSClassExpression);
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

#pragma mark Declaration axioms

// entityID
@synthesize entityID = _entityID;

- (BOOL)setEntityID:(NSString *)ID error:(NSError *__autoreleasing *)error
{
    if (_entityID == ID || [_entityID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_entityID) {
        _entityID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple entities for same declaration axiom."
                                  userInfo:@{@"entities": @[_entityID, ID]}];
    }
    
    return success;
}

#pragma mark Binary class expression axioms

// superClassID
@synthesize LHSClassID = _LHSClassID;

- (BOOL)setLHSClassID:(NSString *)ID error:(NSError *__autoreleasing *)error
{
    if (_LHSClassID == ID || [_LHSClassID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_LHSClassID) {
        _LHSClassID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeParse
                      localizedDescription:@"Multiple left-hand-side IDs for same binary class expression axiom."
                                  userInfo:@{@"IDs": @[_LHSClassID, ID]}];
    }
    
    return success;
}

// subClassID
@synthesize RHSClassID = _RHSClassID;

- (BOOL)setRHSClassID:(NSString *)ID error:(NSError *__autoreleasing *)error
{
    if (_RHSClassID == ID || [_RHSClassID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_RHSClassID) {
        _RHSClassID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeParse
                      localizedDescription:@"Multiple right-hand-side IDs for same binary class expression axiom."
                                  userInfo:@{@"IDs": @[_RHSClassID, ID]}];
    }
    
    return success;
}

@end
