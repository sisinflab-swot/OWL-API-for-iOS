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
#import "RDFNode.h"
#import "RDFStatement.h"
#import "SMRClassUtils.h"

#pragma mark Not implemented handler

static BOOL oNotImplementedHandler(RDFStatement *statement, __unused OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Unsupported object in rdf:type statement."
                                  userInfo:@{@"statement": statement}];
    }
    return NO;
}

#pragma mark Class declaration handler

static BOOL oClassHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RDFNode *subject = statement.subject;
    
    if (subject.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subject of class declaration statement is a literal node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        unsigned char *subjectID = subject.cValue;
        
        // Add class expression builder
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subjectID];
        
        if (![ceb setType:OWLCEBTypeClass error:&localError]) {
            goto err;
        }
        
        if (subject.isResource) {
            // Named class declaration
            if (![ceb setIRI:subjectID error:&localError]) {
                goto err;
            }
            
            // Add declaration axiom builder
            OWLAxiomBuilder *ab = [builder ensureDeclarationAxiomBuilderForID:subjectID];
            
            if (![ab setType:OWLABTypeDeclaration error:&localError]) {
                goto err;
            }
            
            if (![ab setDeclType:OWLABDeclTypeClass error:&localError]) {
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
}

#pragma mark Named individual declaration handler

static BOOL oNamedIndividualHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RDFNode *subject = statement.subject;
    
    if (!subject.isResource) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Named individual declaration statements must have resource-type subject nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Named individual declaration
        unsigned char *subjectID = subject.cValue;
        
        OWLIndividualBuilder *ib = [builder ensureIndividualBuilderForID:subjectID];
        
        if (![ib setType:OWLIBTypeNamed error:&localError]) {
            goto err;
        }
        
        if (![ib setIRI:subjectID error:&localError]) {
            goto err;
        }
        
        // Add declaration axiom builder
        OWLAxiomBuilder *ab = [builder ensureDeclarationAxiomBuilderForID:subjectID];
        
        if (![ab setType:OWLABTypeDeclaration error:&localError]) {
            goto err;
        }
        
        if (![ab setDeclType:OWLABDeclTypeNamedIndividual error:&localError]) {
            goto err;
        }
        
        if (![ab setLHSID:subjectID error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

#pragma mark Object property declaration handler

static BOOL oObjectPropertyHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RDFNode *subject = statement.subject;
    
    if (!subject.isResource) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Object property declaration statements must have resource-type subject nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Object property declaration
        unsigned char *subjectID = subject.cValue;
        
        OWLPropertyBuilder *pb = [builder ensurePropertyBuilderForID:subjectID];
        
        if (![pb setType:OWLPBTypeObjectProperty error:&localError]) {
            goto err;
        }
        
        if (![pb setIRI:subjectID error:&localError]) {
            goto err;
        }
        
        // Add declaration axiom builder
        OWLAxiomBuilder *ab = [builder ensureDeclarationAxiomBuilderForID:subjectID];
        
        if (![ab setType:OWLABTypeDeclaration error:&localError]) {
            goto err;
        }
        
        if (![ab setDeclType:OWLABDeclTypeObjectProperty error:&localError]) {
            goto err;
        }
        
        if (![ab setLHSID:subjectID error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

#pragma mark Ontology IRI declaration handler

static BOOL oOntologyIRIHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RDFNode *subject = statement.subject;
    
    if (!subject.isResource) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Ontology ID statements must have resource-type subject nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        if (![builder setOntologyIRI:subject.cValue error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

#pragma mark Restriction declaration handler

static BOOL oRestrictionHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RDFNode *subject = statement.subject;
    
    if (!subject.isBlank) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Restriction declaration statements must have blank subject nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Restriction declaration
        unsigned char *subjectID = subject.cValue;
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subjectID];
        
        if (![ceb setType:OWLCEBTypeRestriction error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

#pragma mark Transitive property handler

static BOOL oTransitivePropertyHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RDFNode *subject = statement.subject;
    
    if (subject.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Illegal literal subject node in transitive property statement."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Subject is surely an object property expression
        BOOL subjectIsResource = subject.isResource;
        unsigned char *subjectID = subject.cValue;
        
        OWLPropertyBuilder *pb = [builder ensurePropertyBuilderForID:subjectID];
        
        if (subjectIsResource) {
            // Object property
            if (![pb setType:OWLPBTypeObjectProperty error:&localError]) {
                goto err;
            }
            
            if (![pb setIRI:subjectID error:&localError]) {
                goto err;
            }
        }
        
        // Add axiom
        OWLAxiomBuilder *ab = [builder addSingleStatementAxiomBuilder];
        
        if (![ab setType:OWLABTypeTransitiveProperty error:&localError]) {
            goto err;
        }
        
        if (![ab setLHSID:subjectID error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

#pragma mark - Type handler map

OWLMap *rdfTypeHandlerMap;

OWLMap * init_type_handlers(void)
{
    OWLMap *map = owl_map_init(NONE);
    
#define setHandler(term, handler) \
owl_map_set(map, (unsigned char *)[OWLRDFVocabulary term].stringValue.UTF8String, &handler)
    
    setHandler(OWLClass, oClassHandler);
    setHandler(OWLNamedIndividual, oNamedIndividualHandler);
    setHandler(OWLObjectProperty, oObjectPropertyHandler);
    setHandler(OWLOntology, oOntologyIRIHandler);
    setHandler(OWLRestriction, oRestrictionHandler);
    setHandler(OWLTransitiveProperty, oTransitivePropertyHandler);
    
#define handlerNotImplemented(name) \
setHandler(name, oNotImplementedHandler)
    
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
    
    return map;
}
