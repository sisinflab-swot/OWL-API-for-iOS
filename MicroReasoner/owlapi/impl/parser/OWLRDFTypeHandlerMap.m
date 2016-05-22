//
//  OWLRDFTypeHandlerMap.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 21/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLRDFTypeHandlerMap.h"
#import "OWLAxiomBuilder.h"
#import "OWLClassExpressionBuilder.h"
#import "OWLError.h"
#import "OWLIndividualBuilder.h"
#import "OWLOntologyBuilder.h"
#import "OWLPropertyBuilder.h"
#import "OWLRDFVocabulary.h"
#import "SMRPreprocessor.h"
#import <Redland-ObjC.h>

@interface OWLRDFTypeHandlerMap ()
{
    NSDictionary *_handlers;
}
@end


@implementation OWLRDFTypeHandlerMap

NS_INLINE NSDictionary * initHandlers()
{
    NSMutableDictionary<NSString *, OWLStatementHandler> *map = [[NSMutableDictionary alloc] init];
    
    map[[OWLRDFVocabulary OWLClass].stringValue] = [oClassHandler copy];
    map[[OWLRDFVocabulary OWLNamedIndividual].stringValue] = [oNamedIndividualHandler copy];
    map[[OWLRDFVocabulary OWLObjectProperty].stringValue] = [oObjectPropertyHandler copy];
    map[[OWLRDFVocabulary OWLOntology].stringValue] = [oOntologyIRIHandler copy];
    map[[OWLRDFVocabulary OWLRestriction].stringValue] = [oRestrictionHandler copy];
    
    OWLStatementHandler notImplemented = [oNotImplementedHandler copy];
    
#define handlerNotImplemented(name) \
map[[OWLRDFVocabulary name].stringValue] = notImplemented
    
    // Not implemented handlers
    handlerNotImplemented(OWLAllDifferent);
    handlerNotImplemented(OWLAllDisjointClasses);
    handlerNotImplemented(OWLAllDisjointProperties);
    handlerNotImplemented(OWLAnnotation);
    handlerNotImplemented(OWLAnnotationProperty);
    handlerNotImplemented(OWLAsymmetricProperty);
    handlerNotImplemented(OWLAxiom);
    handlerNotImplemented(OWLDatatypeProperty);
    handlerNotImplemented(OWLDeprecatedClass);
    handlerNotImplemented(OWLDeprecatedProperty);
    handlerNotImplemented(OWLFunctionalProperty);
    handlerNotImplemented(OWLInverseFunctionalProperty);
    handlerNotImplemented(OWLIrreflexiveProperty);
    handlerNotImplemented(OWLNegativePropertyAssertion);
    handlerNotImplemented(OWLOntologyProperty);
    handlerNotImplemented(OWLReflexiveProperty);
    handlerNotImplemented(OWLSymmetricProperty);
    handlerNotImplemented(OWLTransitiveProperty);
    
    return map;
}

- (instancetype)init
{
    if ((self = [super init])) {
        _handlers = initHandlers();
    }
    return self;
}

#pragma mark OWLStatementHandlerMap

- (OWLStatementHandler)handlerForSignature:(NSString *)signature
{
    return _handlers[signature];
}

#pragma mark Not implemented handler

OWLStatementHandler oNotImplementedHandler = ^BOOL(RedlandStatement *statement, __unused OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Unsupported object in rdf:type statement."
                                  userInfo:@{@"statement": statement}];
    }
    return NO;
};

#pragma mark Class declaration handler

OWLStatementHandler oClassHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *subject = statement.subject;
    
    if (subject.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subject of class declaration statement is a literal node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        NSString *subjectID = nil;
        
        if (subject.isResource) {
            subjectID = subject.URIStringValue;
        } else {
            subjectID = subject.blankID;
        }
        
        // Add class expression builder
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subjectID error:&localError];
        
        if (![ceb setType:OWLCEBTypeClass error:&localError]) {
            goto err;
        }
        
        if (subject.isResource) {
            // Named class declaration
            if (![ceb setClassID:subjectID error:&localError]) {
                goto err;
            }
            
            // Add declaration axiom builder
            OWLAxiomBuilder *ab = [builder ensureDeclarationAxiomBuilderForID:subjectID];
            
            if (![ab setType:OWLABTypeDeclaration error:&localError]) {
                goto err;
            }
            
            if (![ab setLHSID:subjectID error:&localError]) {
                goto err;
            }
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

#pragma mark Named individual declaration handler

OWLStatementHandler oNamedIndividualHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *subject = statement.subject;
    
    if (subject.isResource) {
        // Named individual declaration
        NSString *IRIString = subject.URIStringValue;
        
        // Add individual builder
        OWLIndividualBuilder *ib = [builder ensureIndividualBuilderForID:IRIString error:&localError];
        
        if (![ib setNamedIndividualID:IRIString error:&localError]) {
            goto err;
        }
        
        // Add declaration axiom builder
        OWLAxiomBuilder *ab = [builder ensureDeclarationAxiomBuilderForID:IRIString];
        
        if (![ab setType:OWLABTypeDeclaration error:&localError]) {
            goto err;
        }
        
        if (![ab setLHSID:IRIString error:&localError]) {
            goto err;
        }
    } else {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Named individual declaration statements must have resource-type subject nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

#pragma mark Object property declaration handler

OWLStatementHandler oObjectPropertyHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *subject = statement.subject;
    
    if (subject.isResource) {
        // Object property declaration
        NSString *IRIString = subject.URIStringValue;
        
        // Add object property builder
        OWLPropertyBuilder *pb = [builder ensurePropertyBuilderForID:IRIString error:&localError];
        
        if (![pb setType:OWLPBTypeObjectProperty error:&localError]) {
            goto err;
        }
        
        if (![pb setNamedPropertyID:IRIString error:&localError]) {
            goto err;
        }
        
        // Add declaration axiom builder
        OWLAxiomBuilder *ab = [builder ensureDeclarationAxiomBuilderForID:IRIString];
        
        if (![ab setType:OWLABTypeDeclaration error:&localError]) {
            goto err;
        }
        
        if (![ab setLHSID:IRIString error:&localError]) {
            goto err;
        }
    } else {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Object property declaration statements must have resource-type subject nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

#pragma mark Ontology IRI declaration handler

OWLStatementHandler oOntologyIRIHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *subject = statement.subject;
    
    if (!subject.isResource) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Ontology ID statements must have resource-type subject nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    if (![builder setOntologyIRI:subject.URIStringValue error:&localError]) {
        goto err;
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

#pragma mark Restriction declaration handler

OWLStatementHandler oRestrictionHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *subject = statement.subject;
    
    if (subject.isBlank) {
        // Restriction declaration
        
        // Add class expression builder
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subject.blankID error:&localError];
        
        if (![ceb setType:OWLCEBTypeRestriction error:&localError]) {
            goto err;
        }
    } else {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Restriction declaration statements must have blank subject nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

@end
