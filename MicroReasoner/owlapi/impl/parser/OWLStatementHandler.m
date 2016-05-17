//
//  OWLStatementHandler.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLStatementHandler.h"
#import "OWLAxiomBuilder.h"
#import "OWLClassExpressionBuilder.h"
#import "OWLError.h"
#import "OWLIndividualBuilder.h"
#import "OWLOntologyBuilder.h"
#import "OWLPropertyBuilder.h"
#import "OWLRDFVocabulary.h"
#import <Redland-ObjC.h>

#pragma mark Object handler map

#define handlerNotImplemented(name) \
map[[OWLRDFVocabulary name].stringValue] = [^BOOL( \
__unused RedlandStatement *s, \
__unused OWLOntologyBuilder *b, \
__unused NSError *__autoreleasing *e) \
{ return YES; } copy]

NS_INLINE NSDictionary *objectHandlerMapInit() {
    NSMutableDictionary<NSString *, OWLStatementHandler> *map = [[NSMutableDictionary alloc] init];
    
    map[[OWLRDFVocabulary OWLClass].stringValue] = [oClassHandler copy];
    map[[OWLRDFVocabulary OWLNamedIndividual].stringValue] = [oNamedIndividualHandler copy];
    map[[OWLRDFVocabulary OWLObjectProperty].stringValue] = [oObjectPropertyHandler copy];
    map[[OWLRDFVocabulary OWLRestriction].stringValue] = [oRestrictionHandler copy];
    
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
    handlerNotImplemented(OWLOntology);
    handlerNotImplemented(OWLOntologyProperty);
    handlerNotImplemented(OWLReflexiveProperty);
    handlerNotImplemented(OWLSymmetricProperty);
    handlerNotImplemented(OWLTransitiveProperty);
    
    return map;
}

#pragma mark Handlers

/// rdf:type predicate handler
OWLStatementHandler pRDFTypeHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    static NSDictionary<NSString *, OWLStatementHandler> *objectHandlerMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objectHandlerMap = objectHandlerMapInit();
    });
    
    
    NSError *__autoreleasing localError = nil;
    RedlandNode *object = statement.object;
    
    if (object.isResource) {
        // Declaration of named entity
        // Class expression declaration
        // Individual named class assertion
        NSString *objectURIString = object.URIStringValue;
        OWLStatementHandler handler = objectHandlerMap[objectURIString];
        
        if (handler) {
            // Declaration of named entity
            // Class expression declaration
            if (!handler(statement, builder, &localError)) {
                goto err;
            }
        } else {
            // Individual named class assertion
            // TODO: implement
        }
    } else {
        // Individual unnamed class assertion
        // TODO: implement
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

/// owl:onProperty predicate handler
OWLStatementHandler pOnPropertyHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError;
    RedlandNode *object = statement.object;
    
    if (object.isResource) {
        // owl:onProperty with named object/datatype property
        // Note: currently only supports object properties.
        NSString *IRIString = object.URIStringValue;
        
        // Add object property builder
        OWLPropertyBuilder *pb = builder.propertyBuilders[IRIString];
        
        if (!pb) {
            pb = [[OWLPropertyBuilder alloc] init];
            [pb setType:OWLPBTypeObjectProperty error:NULL];
            [pb setNamedPropertyID:IRIString error:NULL];
            builder.propertyBuilders[IRIString] = pb;
        }
        
        RedlandNode *subject = statement.subject;
        
        if (subject.isBlank) {
            NSString *blankID = subject.blankID;
            OWLClassExpressionBuilder *ceb = builder.classExpressionBuilders[blankID];
            
            if (!ceb) {
                ceb = [[OWLClassExpressionBuilder alloc] init];
                builder.classExpressionBuilders[blankID] = ceb;
            }
            
            if (![ceb setPropertyID:IRIString error:&localError]) {
                goto err;
            }
        } else {
            localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                              localizedDescription:@"onProperty statements must have blank subject nodes."
                                          userInfo:@{@"statement": statement}];
            goto err;
        }
    } else {
        // owl:onProperty with anonymous property
        // TODO: currently unsupported
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

/// owl:someValuesFrom predicate handler
OWLStatementHandler pSomeValuesFromHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError;
    RedlandNode *object = statement.object;
    
    if (object.isResource) {
        // owl:someValuesFrom with named class/datatype filler
        
        // Add class expression if missing
        NSString *objectURIString = object.URIStringValue;
        
        if(!builder.classExpressionBuilders[objectURIString]) {
            OWLClassExpressionBuilder *ceb = [[OWLClassExpressionBuilder alloc] init];
            [ceb setType:OWLCEBTypeClass error:NULL];
            [ceb setClassID:objectURIString error:NULL];
            builder.classExpressionBuilders[objectURIString] = ceb;
        }
        
        RedlandNode *subject = statement.subject;
        
        if (subject.isBlank) {
            NSString *blankID = subject.blankID;
            OWLClassExpressionBuilder *ceb = builder.classExpressionBuilders[blankID];
            
            if (!ceb) {
                ceb = [[OWLClassExpressionBuilder alloc] init];
                builder.classExpressionBuilders[blankID] = ceb;
            }
            
            if (![ceb setRestrictionType:OWLCEBRestrictionTypeSomeValuesFrom error:&localError]) {
                goto err;
            }
            
            if (![ceb setFillerID:objectURIString error:&localError]) {
                goto err;
            }
        } else {
            localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                              localizedDescription:@"SomeValuesFrom statements must have blank subject nodes."
                                          userInfo:@{@"statement": statement}];
            goto err;
        }
    } else {
        // owl:someValuesFrom with anonymous class/datatype filler
        // TODO: currently unsupported
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

/// Class declaration handler
OWLStatementHandler oClassHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *subject = statement.subject;
    
    if (subject.isResource) {
        // Class declaration
        NSString *IRIString = subject.URIStringValue;
        
        // Add class builder
        OWLClassExpressionBuilder *ceb = builder.classExpressionBuilders[IRIString];
        
        if (!ceb) {
            ceb = [[OWLClassExpressionBuilder alloc] init];
            builder.classExpressionBuilders[IRIString] = ceb;
        }
        
        if (![ceb setType:OWLCEBTypeClass error:&localError]) {
            goto err;
        }
        
        if (![ceb setClassID:IRIString error:&localError]) {
            goto err;
        }
        
        // Add axiom builder
        OWLAxiomBuilder *ab = builder.axiomBuilders[IRIString];
        
        if (!ab) {
            ab = [[OWLAxiomBuilder alloc] initWithOntologyBuilder:builder];
            builder.axiomBuilders[IRIString] = ab;
        }
        
        if (![ab setType:OWLABTypeDeclaration error:&localError]) {
            goto err;
        }
        
        if (![ab setEntityID:IRIString error:&localError]) {
            goto err;
        }
    } else {
        // Class expression declaration
        // TODO: implement
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

/// Named individual declaration handler
OWLStatementHandler oNamedIndividualHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *subject = statement.subject;
    
    if (subject.isResource) {
        // Named individual declaration
        NSString *IRIString = subject.URIStringValue;
        
        // Add individual builder
        OWLIndividualBuilder *ib = builder.individualBuilders[IRIString];
        
        if (!ib) {
            ib = [[OWLIndividualBuilder alloc] init];
            builder.individualBuilders[IRIString] = ib;
        }
        
        if (![ib setNamedIndividualID:IRIString error:&localError]) {
            goto err;
        }
        
        // Add axiom builder
        OWLAxiomBuilder *ab = builder.axiomBuilders[IRIString];
        
        if (!ab) {
            ab = [[OWLAxiomBuilder alloc] initWithOntologyBuilder:builder];
            builder.axiomBuilders[IRIString] = ab;
        }
        
        if (![ab setType:OWLABTypeDeclaration error:&localError]) {
            goto err;
        }
        
        if (![ab setEntityID:IRIString error:&localError]) {
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

/// Object property declaration handler
OWLStatementHandler oObjectPropertyHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *subject = statement.subject;
    
    if (subject.isResource) {
        // Object property declaration
        NSString *IRIString = subject.URIStringValue;
        
        // Add object property builder
        OWLPropertyBuilder *pb = builder.propertyBuilders[IRIString];
        
        if (!pb) {
            pb = [[OWLPropertyBuilder alloc] init];
            builder.propertyBuilders[IRIString] = pb;
        }
        
        if (![pb setType:OWLPBTypeObjectProperty error:&localError]) {
            goto err;
        }
        
        if (![pb setNamedPropertyID:IRIString error:&localError]) {
            goto err;
        }
        
        // Add axiom builder
        OWLAxiomBuilder *ab = builder.axiomBuilders[IRIString];
        
        if (!ab) {
            ab = [[OWLAxiomBuilder alloc] initWithOntologyBuilder:builder];
            builder.axiomBuilders[IRIString] = ab;
        }
        
        if (![ab setType:OWLABTypeDeclaration error:&localError]) {
            goto err;
        }
        
        if (![ab setEntityID:IRIString error:&localError]) {
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

/// Restriction declaration handler
OWLStatementHandler oRestrictionHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *subject = statement.subject;
    
    if (subject.isBlank) {
        // Restriction declaration
        NSString *blankID = subject.blankID;
        
        // Add class expression builder
        OWLClassExpressionBuilder *ceb = builder.classExpressionBuilders[blankID];
        if (!ceb) {
            ceb = [[OWLClassExpressionBuilder alloc] init];
            builder.classExpressionBuilders[blankID] = ceb;
        }
        
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
