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
#import "OWLListItem.h"
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
    map[[OWLRDFVocabulary OWLOntology].stringValue] = [oOntologyIRIHandler copy];
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
    handlerNotImplemented(OWLOntologyProperty);
    handlerNotImplemented(OWLReflexiveProperty);
    handlerNotImplemented(OWLSymmetricProperty);
    handlerNotImplemented(OWLTransitiveProperty);
    
    return map;
}

#pragma mark rdf:type predicate handler

NS_INLINE BOOL handleClassAssertionStatement(RedlandStatement *statement, OWLOntologyBuilder *builder, BOOL named, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *subject = statement.subject;
    
    if (!subject.isResource) {
        // TODO: anonymous individuals are currently unsupported
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Anonymous individuals are not supported."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Add individual
        NSString *subjectID = subject.URIStringValue;
        
        OWLIndividualBuilder *ib = [builder ensureIndividualBuilderForID:subjectID error:&localError];
        
        if (![ib setNamedIndividualID:subjectID error:&localError]) {
            goto err;
        }
        
        // Add class expression
        NSString *objectID = (named ? statement.object.URIStringValue : statement.object.blankID);
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:objectID error:&localError];
        
        if (!ceb) {
            goto err;
        }
        
        if (named) {
            if (![ceb setType:OWLCEBTypeClass error:&localError]) {
                goto err;
            }
            
            if (![ceb setClassID:objectID error:&localError]) {
                goto err;
            }
        }
        
        // Add class assertion axiom
        OWLAxiomBuilder *ab = [builder addSingleStatementAxiomBuilderForID:subjectID];
        
        if (![ab setType:OWLABTypeClassAssertion error:&localError]) {
            goto err;
        }
        
        if (![ab setLHSID:subjectID error:&localError]) {
            goto err;
        }
        
        if (![ab setRHSID:objectID error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

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
            if (!handleClassAssertionStatement(statement, builder, YES, &localError)) {
                goto err;
            }
        }
    } else {
        // Individual unnamed class assertion
        if (!handleClassAssertionStatement(statement, builder, NO, &localError)) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

#pragma mark rdf:first and rdf:rest predicate handlers

NS_INLINE BOOL handleListStatement(RedlandStatement *statement, OWLOntologyBuilder *builder, BOOL first, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RedlandNode *subject = statement.subject;
    RedlandNode *object = statement.object;
    
    if (!subject.isBlank) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subject of list statement is not a blank node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    if (object.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Object of list statement is a literal node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Add list item
        NSString *subjectID = subject.blankID;
        NSString *objectID = nil;
        
        if (object.isResource) {
            objectID = object.URIStringValue;
        } else {
            objectID = object.blankID;
        }
        
        OWLListItem *item = [builder ensureListItemForID:subjectID];
        
        if (first) {
            item.first = objectID;
        } else {
            item.rest = objectID;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

OWLStatementHandler pRDFFirstHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleListStatement(statement, builder, YES, error);
};

OWLStatementHandler pRDFRestHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleListStatement(statement, builder, NO, error);
};

#pragma mark owl:allValuesFrom and owl:someValuesFrom predicate handlers

NS_INLINE BOOL handleQuantificationStatement(RedlandStatement *statement, OWLOntologyBuilder *builder, BOOL universal, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RedlandNode *subject = statement.subject;
    RedlandNode *object = statement.object;
    
    if (!subject.isBlank) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subject of quantified restriction statement is not a blank node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    if (object.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Object of quantified restriction statement is a literal node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Add filler class expression
        NSString *fillerID = nil;
        BOOL objectIsResource = object.isResource;
        
        if (objectIsResource) {
            // Named class/datatype filler
            fillerID = object.URIStringValue;
        } else {
            // Anonymous class/datatype filler
            fillerID = object.blankID;
        }
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:fillerID error:&localError];
        
        if (!ceb) {
            goto err;
        }
        
        if (objectIsResource) {
            if (![ceb setType:OWLCEBTypeClass error:&localError]) {
                goto err;
            }
            
            if (![ceb setClassID:fillerID error:&localError]) {
                goto err;
            }
        }
        
        
        // Add restriction
        NSString *subjectID = subject.blankID;
        ceb = [builder ensureClassExpressionBuilderForID:subjectID error:&localError];
        
        OWLCEBRestrictionType restrictionType = (universal ? OWLCEBRestrictionTypeAllValuesFrom : OWLCEBRestrictionTypeSomeValuesFrom);
        if (![ceb setRestrictionType:restrictionType error:&localError]) {
            goto err;
        }
        
        if (![ceb setFillerID:fillerID error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

OWLStatementHandler pAllValuesFromHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleQuantificationStatement(statement, builder, YES, error);
};

OWLStatementHandler pSomeValuesFromHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleQuantificationStatement(statement, builder, NO, error);
};

#pragma mark owl:cardinality, owl:minCardinality and owl:maxCardinality predicate handlers

NS_INLINE BOOL handleCardinalityStatement(RedlandStatement *statement, OWLOntologyBuilder *builder, OWLCEBRestrictionType restrType, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RedlandNode *subject = statement.subject;
    RedlandNode *object = statement.object;
    
    if (!subject.isBlank) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subject of cardinality statement is not a blank node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    if (!object.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Object of cardinality statement is not a literal node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Add restriction
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subject.blankID error:&localError];
        
        if (![ceb setRestrictionType:restrType error:&localError]) {
            goto err;
        }
        
        if (![ceb setCardinality:object.literalValue error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
    
}

OWLStatementHandler pCardinalityHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleCardinalityStatement(statement, builder, OWLCEBRestrictionTypeCardinality, error);
};

OWLStatementHandler pMinCardinalityHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleCardinalityStatement(statement, builder, OWLCEBRestrictionTypeMinCardinality, error);
};

OWLStatementHandler pMaxCardinalityHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleCardinalityStatement(statement, builder, OWLCEBRestrictionTypeMaxCardinality, error);
};

#pragma mark owl:disjointWith, owl:equivalentClass and rdfs:subClassOf predicate handlers

NS_INLINE BOOL handleBinaryCEAxiomStatement(RedlandStatement *statement, OWLOntologyBuilder *builder, OWLABType axiomType, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RedlandNode *subject = statement.subject;
    RedlandNode *object = statement.object;
    
    if (subject.isLiteral || object.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subject or object of binary class expression axiom statement is a literal node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // LHS class expression
        NSString *LHSClassID = nil;
        BOOL isResource = subject.isResource;
        
        if (isResource) {
            LHSClassID = subject.URIStringValue;
        } else {
            LHSClassID = subject.blankID;
        }
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:LHSClassID error:&localError];
        
        if (isResource) {
            if (![ceb setType:OWLCEBTypeClass error:&localError]) {
                goto err;
            }
            
            if (![ceb setClassID:LHSClassID error:&localError]) {
                goto err;
            }
        }
        
        // RHS class expression
        NSString *RHSClassID = nil;
        isResource = object.isResource;
        
        if (isResource) {
            RHSClassID = object.URIStringValue;
        } else {
            RHSClassID = object.blankID;
        }
        
        ceb = [builder ensureClassExpressionBuilderForID:RHSClassID error:&localError];
        
        if (isResource) {
            if (![ceb setType:OWLCEBTypeClass error:&localError]) {
                goto err;
            }
            
            if (![ceb setClassID:RHSClassID error:&localError]) {
                goto err;
            }
        }
        
        // Axiom
        OWLAxiomBuilder *ab = [builder addSingleStatementAxiomBuilderForID:LHSClassID];
        
        // No need to check for errors, since it will be a new object.
        [ab setType:axiomType error:NULL];
        [ab setRHSID:RHSClassID error:NULL];
        [ab setLHSID:LHSClassID error:NULL];
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

OWLStatementHandler pDisjointWithHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleBinaryCEAxiomStatement(statement, builder, OWLABTypeDisjointClasses, error);
};

OWLStatementHandler pEquivalentClassHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleBinaryCEAxiomStatement(statement, builder, OWLABTypeEquivalentClasses, error);
};

OWLStatementHandler pSubClassOfHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleBinaryCEAxiomStatement(statement, builder, OWLABTypeSubClassOf, error);
};

#pragma mark owl:intersectionOf predicate handler

OWLStatementHandler pIntersectionOfHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RedlandNode *subject = statement.subject;
    RedlandNode *object = statement.object;
    
    if (!(subject.isBlank && object.isBlank)) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subject or object of 'owl:intersectionOf' statement is not a blank node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Add class expression
        NSString *subjectID = subject.blankID;
        NSString *objectID = object.blankID;
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subjectID error:&localError];
        
        if (![ceb setBooleanType:OWLCEBBooleanTypeIntersection error:&localError]) {
            goto err;
        }
        
        if (![ceb setListID:objectID error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

#pragma mark owl:onProperty predicate handler

OWLStatementHandler pOnPropertyHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *object = statement.object;
    
    if (object.isResource) {
        // owl:onProperty with named object/datatype property
        // Note: currently only supports object properties.
        NSString *IRIString = object.URIStringValue;
        
        // Add object property builder
        // We assume it's an object property since it's
        // the only supported property expression type.
        OWLPropertyBuilder *pb = [builder ensurePropertyBuilderForID:IRIString error:&localError];
        
        if (![pb setType:OWLPBTypeObjectProperty error:&localError]) {
            goto err;
        }
        
        if (![pb setNamedPropertyID:IRIString error:NULL]) {
            goto err;
        }
        
        RedlandNode *subject = statement.subject;
        
        if (subject.isBlank) {
            OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subject.blankID error:&localError];
            
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

#pragma mark rdfs:domain and rdfs:range predicate handlers

NS_INLINE BOOL handleDomainRangeStatement(RedlandStatement *statement, OWLOntologyBuilder *builder, BOOL domain, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RedlandNode *subject = statement.subject;
    RedlandNode *object = statement.object;
    
    if (subject.isLiteral || object.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Illegal subject/object literal node for statement."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // TODO: only supports object properties
        // Add object property builder
        // We assume it's an object property since it's
        // the only supported property expression type.
        NSString *subjectID = nil;
        
        if (subject.isResource) {
            subjectID = subject.URIStringValue;
        } else {
            subjectID = subject.blankID;
        }
        
        OWLPropertyBuilder *pb = [builder ensurePropertyBuilderForID:subjectID error:&localError];
        
        if (![pb setType:OWLPBTypeObjectProperty error:&localError]) {
            goto err;
        }
        
        if (![pb setNamedPropertyID:subjectID error:&localError]) {
            goto err;
        }
        
        // Add class expression builder
        NSString *objectID = nil;
        BOOL objectIsResource = object.isResource;
        
        if (objectIsResource) {
            objectID = object.URIStringValue;
        } else {
            objectID = object.blankID;
        }
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:objectID error:&localError];
        
        if (!ceb) {
            goto err;
        }
        
        if (objectIsResource) {
            if (![ceb setType:OWLCEBTypeClass error:&localError]) {
                goto err;
            }
            
            if (![ceb setClassID:objectID error:&localError]) {
                goto err;
            }
        }
        
        // Add axiom
        OWLAxiomBuilder *ab = [builder addSingleStatementAxiomBuilderForID:subjectID
                                                          ensureUniqueType:(domain ? OWLABTypeDomain : OWLABTypeRange)];
        if (ab) {
            if (![ab setLHSID:subjectID error:&localError]) {
                goto err;
            }
            
            if (![ab setRHSID:objectID error:&localError]) {
                goto err;
            }
        } else {
            localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                              localizedDescription:@"Multiple domain/range axioms for same property expression."
                                          userInfo:@{@"statement": statement}];
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

OWLStatementHandler pDomainHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleDomainRangeStatement(statement, builder, YES, error);
};

OWLStatementHandler pRangeHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleDomainRangeStatement(statement, builder, NO, error);
};

#pragma mark Ontology version IRI handler

OWLStatementHandler pVersionIRIHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RedlandNode *subject = statement.subject;
    RedlandNode *object = statement.object;
    
    if (!(subject.isResource && object.isResource)) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subject and object of version IRI statement must be resource nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    if (![builder setOntologyIRI:subject.URIStringValue error:&localError]) {
        goto err;
    }
    
    if (![builder setVersionIRI:object.URIStringValue error:&localError]) {
        goto err;
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
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
