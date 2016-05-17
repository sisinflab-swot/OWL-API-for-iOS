//
//  OWLAxiomBuilder.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAxiomBuilder.h"
#import "OWLDeclarationAxiomImpl.h"
#import "OWLError.h"
#import "OWLOntologyBuilder.h"

@interface OWLAxiomBuilder ()

@property (nonatomic, weak, readonly) OWLOntologyBuilder *ontologyBuilder;

@end


@implementation OWLAxiomBuilder

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
    id<OWLAxiom> builtAxiom = nil;
    
    switch(self.type) {
        case OWLABTypeDeclaration:
        {
            OWLOntologyBuilder *builder = self.ontologyBuilder;
            NSString *entityID = self.entityID;
            id<OWLEntity> entity = nil;
            
            if (entityID) {
                NSArray *maps = @[builder.classExpressionBuilders,
                                  builder.propertyBuilders,
                                  builder.individualBuilders];
                
                for (NSDictionary *map in maps) {
                    entity = [(id<OWLAbstractBuilder>)map[entityID] build];
                    if (entity) {
                        break;
                    }
                }
            }
            
            if (entity) {
                builtAxiom = [[OWLDeclarationAxiomImpl alloc] initWithEntity:entity];
            }
            break;
        }
            
        default:
            break;
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

@end
