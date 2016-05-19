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
        case OWLABTypeDeclaration:
        {
            NSString *entityID = self.entityID;
            
            if (entityID) {
                id<OWLEntity> entity = [[self.ontologyBuilder entityBuilderForID:entityID] build];
                
                if (entity) {
                    builtAxiom = [[OWLDeclarationAxiomImpl alloc] initWithEntity:entity];
                }
            }
            
            break;
        }
            
        case OWLABTypeSubClassOf:
        {
            NSString *superClassID = self.superClassID;
            NSString *subClassID = self.subClassID;
            
            if (superClassID && subClassID) {
                OWLOntologyBuilder *ontoBuilder = self.ontologyBuilder;
                
                id<OWLClassExpression> superClassCE = [[ontoBuilder classExpressionBuilderForID:superClassID] build];
                id<OWLClassExpression> subClassCE = [[ontoBuilder classExpressionBuilderForID:subClassID] build];
                
                if (superClassCE && subClassCE) {
                    builtAxiom = [[OWLSubClassOfAxiomImpl alloc] initWithSuperClass:superClassCE subClass:subClassCE];
                }
            }
        }
            
        default:
            break;
    }
    
    self.builtAxiom = builtAxiom;
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

#pragma mark SubClassOf axioms

// superClassID
@synthesize superClassID = _superClassID;

- (BOOL)setSuperClassID:(NSString *)ID error:(NSError *__autoreleasing *)error
{
    if (_superClassID == ID || [_superClassID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_superClassID) {
        _superClassID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeParse
                      localizedDescription:@"Multiple superclass IDs for same subclass axiom."
                                  userInfo:@{@"IDs": @[_superClassID, ID]}];
    }
    
    return success;
}

// subClassID
@synthesize subClassID = _subClassID;

- (BOOL)setSubClassID:(NSString *)ID error:(NSError *__autoreleasing *)error
{
    if (_subClassID == ID || [_subClassID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_subClassID) {
        _subClassID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeParse
                      localizedDescription:@"Multiple subclass IDs for same subclass axiom."
                                  userInfo:@{@"IDs": @[_subClassID, ID]}];
    }
    
    return success;
}

@end
