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

#pragma mark rdf:type predicate handler

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

#pragma mark owl:allValuesFrom predicate handler

OWLStatementHandler pAllValuesFromHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RedlandNode *subject = statement.subject;
    RedlandNode *object = statement.object;
    
    if (!subject.isBlank) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subject of 'allValuesFrom' statement is not a blank node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    if (object.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Object of 'allValuesFrom' statement is a literal node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Add filler class expression
        NSString *fillerID = nil;
        OWLCEBType fillerType = OWLCEBTypeUnknown;
        
        if (object.isResource) {
            // Named class/datatype filler
            fillerID = object.URIStringValue;
            fillerType = OWLCEBTypeClass;
        } else {
            // Anonymous class/datatype filler
            fillerID = object.blankID;
        }
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:fillerID];
        
        if (![ceb setType:fillerType error:&localError]) {
            goto err;
        }
        
        // Add restriction
        NSString *subjectID = subject.blankID;
        ceb = [builder ensureClassExpressionBuilderForID:subjectID];
        
        if (![ceb setRestrictionType:OWLCEBRestrictionTypeAllValuesFrom error:&localError]) {
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
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subject.blankID];
        
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
        OWLCEBType type = OWLCEBTypeUnknown;
        
        if (subject.isResource) {
            // Named LHS class
            LHSClassID = subject.URIStringValue;
            type = OWLCEBTypeClass;
        } else {
            // Anonymous LHS class expression
            LHSClassID = subject.blankID;
        }
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:LHSClassID];
        
        if (![ceb setType:type error:&localError]) {
            goto err;
        }
        
        // RHS class expression
        NSString *RHSClassID = nil;
        type = OWLCEBTypeUnknown;
        
        if (object.isResource) {
            // Named RHS class
            RHSClassID = object.URIStringValue;
            type = OWLCEBTypeClass;
        } else {
            // Anonymous RHS class expression
            RHSClassID = object.blankID;
        }
        
        ceb = [builder ensureClassExpressionBuilderForID:RHSClassID];
        
        if (![ceb setType:type error:&localError]) {
            goto err;
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
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subjectID];
        
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
        OWLPropertyBuilder *pb = [builder ensurePropertyBuilderForID:IRIString];
        
        if (![pb setType:OWLPBTypeObjectProperty error:&localError]) {
            goto err;
        }
        
        if (![pb setNamedPropertyID:IRIString error:NULL]) {
            goto err;
        }
        
        RedlandNode *subject = statement.subject;
        
        if (subject.isBlank) {
            OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subject.blankID];
            
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
        
        OWLPropertyBuilder *pb = [builder ensurePropertyBuilderForID:subjectID];
        
        if (![pb setType:OWLPBTypeObjectProperty error:&localError]) {
            goto err;
        }
        
        if (![pb setNamedPropertyID:subjectID error:&localError]) {
            goto err;
        }
        
        // Add class expression builder
        NSString *objectID = nil;
        
        if (object.isResource) {
            objectID = object.URIStringValue;
        } else {
            objectID = object.blankID;
        }
        
        [builder ensureClassExpressionBuilderForID:objectID];
        
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

#pragma mark owl:someValuesFrom predicate handler

OWLStatementHandler pSomeValuesFromHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *object = statement.object;
    
    if (object.isResource) {
        // owl:someValuesFrom with named class/datatype filler
        NSString *objectIRIString = object.URIStringValue;
        
        // Add filler class expression if missing
        // We assume it's a named class since owl:thing
        // is the only filler we need to support.
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:objectIRIString];
        
        if (![ceb setType:OWLCEBTypeClass error:&localError]) {
            goto err;
        }
        
        if (![ceb setClassID:objectIRIString error:&localError]) {
            goto err;
        }
        
        RedlandNode *subject = statement.subject;
        
        if (subject.isBlank) {
            ceb = [builder ensureClassExpressionBuilderForID:subject.blankID];
            
            if (![ceb setRestrictionType:OWLCEBRestrictionTypeSomeValuesFrom error:&localError]) {
                goto err;
            }
            
            if (![ceb setFillerID:objectIRIString error:&localError]) {
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
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subjectID];
        
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
        OWLIndividualBuilder *ib = [builder ensureIndividualBuilderForID:IRIString];
        
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
        OWLPropertyBuilder *pb = [builder ensurePropertyBuilderForID:IRIString];
        
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

#pragma mark Restriction declaration handler

OWLStatementHandler oRestrictionHandler = ^BOOL(RedlandStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RedlandNode *subject = statement.subject;
    
    if (subject.isBlank) {
        // Restriction declaration
        
        // Add class expression builder
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subject.blankID];
        
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
