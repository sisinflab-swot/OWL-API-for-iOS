//
//  Created by Ivano Bilenchi on 21/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLPredicateHandlerMap.h"
#import "OWLAxiomBuilder.h"
#import "OWLClassExpressionBuilder.h"
#import "OWLError.h"
#import "OWLIndividualBuilder.h"
#import "OWLListItem.h"
#import "OWLMap.h"
#import "OWLOntologyBuilder.h"
#import "OWLPropertyBuilder.h"
#import "OWLRDFTypeHandlerMap.h"
#import "OWLRDFVocabulary.h"
#import "RDFNode.h"
#import "RDFStatement.h"

#pragma mark Unsupported predicate handler

static BOOL pUnsupportedPredicateHandler(RDFStatement *statement, __unused OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Unsupported predicate in statement."
                                  userInfo:@{@"statement": statement}];
    }
    return NO;
}

#pragma mark rdf:type predicate handler

NS_INLINE BOOL handleClassAssertionStatement(RDFStatement *statement, OWLOntologyBuilder *builder, BOOL named, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RDFNode *subject = statement.subject;
    
    if (subject.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Illegal literal subject node in class assertion statement."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Add individual
        BOOL namedIndividual = subject.isResource;
        unsigned char *subjectID = subject.cValue;
        
        OWLIndividualBuilder *ib = [builder ensureIndividualBuilderForID:subjectID];
        
        if (![ib setType:(namedIndividual ? OWLIBTypeNamed : OWLIBTypeAnonymous) error:&localError]) {
            goto err;
        }
        
        if (namedIndividual && ![ib setIRI:subjectID error:&localError]) {
            goto err;
        }
        
        // Add class expression
        RDFNode *object = statement.object;
        unsigned char *objectID = object.cValue;
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:objectID];
        
        if (named) {
            if (![ceb setType:OWLCEBTypeClass error:&localError]) {
                goto err;
            }
            
            if (![ceb setIRI:objectID error:&localError]) {
                goto err;
            }
        }
        
        // Add class assertion axiom
        OWLAxiomBuilder *ab = [builder addSingleStatementAxiomBuilder];
        
        [ab setType:OWLABTypeClassAssertion error:NULL];
        
        [ab setLHSID:subjectID error:NULL];
        [ab setRHSID:objectID error:NULL];
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

static BOOL pRDFTypeHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    RDFNode *object = statement.object;
    
    if (object.isResource) {
        
        OWLStatementHandler handler = owl_map_get(rdfTypeHandlerMap, object.cValue);
        
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
}

#pragma mark Property assertion handler

static BOOL pPropertyAssertionHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RDFNode *subject = statement.subject;
    RDFNode *predicate = statement.predicate;
    RDFNode *object = statement.object;
    
    if (object.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Data property assertions and annotations are not supported."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        BOOL subjectIsResource = subject.isResource;
        BOOL objectIsResource = object.isResource;
        
        unsigned char *subjectID = subject.cValue;
        unsigned char *predicateID = predicate.cValue;
        unsigned char *objectID = object.cValue;
        
        // Add subject individual builder
        OWLIndividualBuilder *ib = [builder ensureIndividualBuilderForID:subjectID];
        
        if (subjectIsResource) {
            if (![ib setType:OWLIBTypeNamed error:&localError]) {
                goto err;
            }
            
            if (![ib setIRI:subjectID error:&localError]) {
                goto err;
            }
        }
        
        // Add object individual builder
        ib = [builder ensureIndividualBuilderForID:objectID];
        
        if (objectIsResource) {
            if (![ib setType:OWLIBTypeNamed error:&localError]) {
                goto err;
            }
            
            if (![ib setIRI:objectID error:&localError]) {
                goto err;
            }
        }
        
        // Add axiom builder
        OWLAxiomBuilder *ab = [builder addSingleStatementAxiomBuilder];
        
        [ab setType:OWLABTypePropertyAssertion error:NULL];
        [ab setLHSID:subjectID error:NULL];
        [ab setMID:predicateID error:NULL];
        [ab setRHSID:objectID error:NULL];
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

#pragma mark rdf:first and rdf:rest predicate handlers

NS_INLINE BOOL handleListStatement(RDFStatement *statement, OWLOntologyBuilder *builder, BOOL first, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RDFNode *subject = statement.subject;
    RDFNode *object = statement.object;
    
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
        unsigned char *subjectID = subject.cValue;
        unsigned char *objectID = object.cValue;
        
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

static BOOL pRDFFirstHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleListStatement(statement, builder, YES, error);
}

static BOOL pRDFRestHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleListStatement(statement, builder, NO, error);
}

#pragma mark owl:allValuesFrom and owl:someValuesFrom predicate handlers

NS_INLINE BOOL handleQuantificationStatement(RDFStatement *statement, OWLOntologyBuilder *builder, BOOL universal, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RDFNode *subject = statement.subject;
    RDFNode *object = statement.object;
    
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
        BOOL objectIsResource = object.isResource;
        unsigned char *fillerID = object.cValue;
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:fillerID];
        
        if (objectIsResource) {
            if (![ceb setType:OWLCEBTypeClass error:&localError]) {
                goto err;
            }
            
            if (![ceb setIRI:fillerID error:&localError]) {
                goto err;
            }
        }
        
        // Add restriction
        unsigned char *subjectID = subject.cValue;
        ceb = [builder ensureClassExpressionBuilderForID:subjectID];
        
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

static BOOL pAllValuesFromHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleQuantificationStatement(statement, builder, YES, error);
}

static BOOL pSomeValuesFromHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleQuantificationStatement(statement, builder, NO, error);
}

#pragma mark owl:cardinality, owl:minCardinality and owl:maxCardinality predicate handlers

NS_INLINE BOOL handleCardinalityStatement(RDFStatement *statement, OWLOntologyBuilder *builder, OWLCEBRestrictionType restrType, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RDFNode *subject = statement.subject;
    RDFNode *object = statement.object;
    
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
        unsigned char *subjectID = subject.cValue;
        NSString *objectValue = object.literalValue;
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subjectID];
        
        if (![ceb setRestrictionType:restrType error:&localError]) {
            goto err;
        }
        
        if (![ceb setCardinality:objectValue error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
    
}

static BOOL pCardinalityHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleCardinalityStatement(statement, builder, OWLCEBRestrictionTypeCardinality, error);
}

static BOOL pMinCardinalityHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleCardinalityStatement(statement, builder, OWLCEBRestrictionTypeMinCardinality, error);
}

static BOOL pMaxCardinalityHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleCardinalityStatement(statement, builder, OWLCEBRestrictionTypeMaxCardinality, error);
}

#pragma mark owl:disjointWith, owl:equivalentClass and rdfs:subClassOf predicate handlers

NS_INLINE BOOL handleBinaryCEAxiomStatement(RDFStatement *statement, OWLOntologyBuilder *builder, OWLABType axiomType, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RDFNode *subject = statement.subject;
    RDFNode *object = statement.object;
    
    if (subject.isLiteral || object.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subject or object of binary class expression axiom statement is a literal node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // LHS class expression
        BOOL isResource = subject.isResource;
        unsigned char *LHSClassID = subject.cValue;
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:LHSClassID];
        
        if (isResource) {
            if (![ceb setType:OWLCEBTypeClass error:&localError]) {
                goto err;
            }
            
            if (![ceb setIRI:LHSClassID error:&localError]) {
                goto err;
            }
        }
        
        // RHS class expression
        isResource = object.isResource;
        unsigned char *RHSClassID = object.cValue;
        
        ceb = [builder ensureClassExpressionBuilderForID:RHSClassID];
        
        if (isResource) {
            if (![ceb setType:OWLCEBTypeClass error:&localError]) {
                goto err;
            }
            
            if (![ceb setIRI:RHSClassID error:&localError]) {
                goto err;
            }
        }
        
        // Axiom
        OWLAxiomBuilder *ab = [builder addSingleStatementAxiomBuilder];
        
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

static BOOL pDisjointWithHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleBinaryCEAxiomStatement(statement, builder, OWLABTypeDisjointClasses, error);
}

static BOOL pEquivalentClassHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleBinaryCEAxiomStatement(statement, builder, OWLABTypeEquivalentClasses, error);
}

static BOOL pSubClassOfHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleBinaryCEAxiomStatement(statement, builder, OWLABTypeSubClassOf, error);
}

#pragma mark owl:complementOf predicate handler

static BOOL pComplementOfHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RDFNode *subject = statement.subject;
    RDFNode *object = statement.object;
    
    if (!subject.isBlank) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subject of complement statement is not a blank node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    if (object.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Object of complement statement is a literal node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Add operand class expression
        BOOL objectIsResource = object.isResource;
        unsigned char *operandID = object.cValue;
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:operandID];
        
        if (objectIsResource) {
            if (![ceb setType:OWLCEBTypeClass error:&localError]) {
                goto err;
            }
            
            if (![ceb setIRI:operandID error:&localError]) {
                goto err;
            }
        }
        
        // Add class expression
        unsigned char *subjectID = subject.cValue;
        ceb = [builder ensureClassExpressionBuilderForID:subjectID];
        
        if (![ceb setBooleanType:OWLCEBBooleanTypeComplement error:&localError]) {
            goto err;
        }
        
        if (![ceb setOperandID:operandID error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

#pragma mark owl:intersectionOf predicate handler

static BOOL pIntersectionOfHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RDFNode *subject = statement.subject;
    RDFNode *object = statement.object;
    
    if (!(subject.isBlank && object.isBlank)) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subject or object of 'owl:intersectionOf' statement is not a blank node."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Add class expression
        unsigned char *subjectID = subject.cValue;
        unsigned char *objectID = object.cValue;
        
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
}

#pragma mark owl:onProperty predicate handler

static BOOL pOnPropertyHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RDFNode *subject = statement.subject;
    RDFNode *object = statement.object;
    
    if (!subject.isBlank) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"onProperty statements must have blank subject nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    if (!object.isResource) {
        // onProperty statements may also have blank object nodes, though
        // in that case they would be anonymous properties (e.g. owl:inverseOf),
        // which are currently unsupported.
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"onProperty statements must have resource object nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // owl:onProperty with named object/datatype property
        // Note: currently only supports object properties, so
        // we assume the property is such.
        unsigned char *objectID = object.cValue;
        OWLPropertyBuilder *pb = [builder ensurePropertyBuilderForID:objectID];
        
        if (![pb setType:OWLPBTypeObjectProperty error:&localError]) {
            goto err;
        }
        
        if (![pb setIRI:objectID error:NULL]) {
            goto err;
        }
        
        // Add class expression builder
        unsigned char *subjectID = subject.cValue;
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:subjectID];
        
        if (![ceb setPropertyID:objectID error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

#pragma mark rdfs:domain and rdfs:range predicate handlers

NS_INLINE BOOL handleDomainRangeStatement(RDFStatement *statement, OWLOntologyBuilder *builder, BOOL domain, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RDFNode *subject = statement.subject;
    RDFNode *object = statement.object;
    
    if (subject.isLiteral || object.isLiteral) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Illegal subject/object literal node for statement."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        // Add object property builder
        // We assume it's an object property since it's
        // the only supported property expression type.
        unsigned char *subjectID = subject.cValue;
        OWLPropertyBuilder *pb = [builder ensurePropertyBuilderForID:subjectID];
        
        if (![pb setType:OWLPBTypeObjectProperty error:&localError]) {
            goto err;
        }
        
        if (![pb setIRI:subjectID error:&localError]) {
            goto err;
        }
        
        // Add class expression builder
        BOOL objectIsResource = object.isResource;
        unsigned char *objectID = object.cValue;
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:objectID];
        
        if (objectIsResource) {
            if (![ceb setType:OWLCEBTypeClass error:&localError]) {
                goto err;
            }
            
            if (![ceb setIRI:objectID error:&localError]) {
                goto err;
            }
        }
        
        // Add axiom builder
        OWLAxiomBuilder *ab = [builder addSingleStatementAxiomBuilder];
        
        [ab setType:(domain ? OWLABTypeDomain : OWLABTypeRange) error:NULL];
        [ab setLHSID:subjectID error:NULL];
        [ab setRHSID:objectID error:NULL];
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

static BOOL pDomainHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleDomainRangeStatement(statement, builder, YES, error);
}

static BOOL pRangeHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleDomainRangeStatement(statement, builder, NO, error);
}

#pragma mark Ontology version IRI handler

static BOOL pVersionIRIHandler(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    NSError *__autoreleasing localError = nil;
    
    RDFNode *subject = statement.subject;
    RDFNode *object = statement.object;
    
    if (!(subject.isResource && object.isResource)) {
        localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                          localizedDescription:@"Subject and object of version IRI statement must be resource nodes."
                                      userInfo:@{@"statement": statement}];
        goto err;
    }
    
    {
        if (![builder setOntologyIRI:subject.cValue error:&localError]) {
            goto err;
        }
        
        if (![builder setVersionIRI:object.cValue error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
}

#pragma mark - Predicate handler map

OWLMap *predicateHandlerMap;

OWLMap * init_predicate_handlers(void)
{
    OWLMap *map = owl_map_init(NONE);
    
#define setHandler(term, handler) \
owl_map_set(map, (unsigned char *)[OWLRDFVocabulary term].stringValue.UTF8String, &handler)
    
    setHandler(RDFFirst, pRDFFirstHandler);
    setHandler(RDFRest, pRDFRestHandler);
    setHandler(RDFType, pRDFTypeHandler);
    setHandler(RDFSDomain, pDomainHandler);
    setHandler(RDFSRange, pRangeHandler);
    setHandler(RDFSSubClassOf, pSubClassOfHandler);
    setHandler(OWLAllValuesFrom, pAllValuesFromHandler);
    setHandler(OWLCardinality, pCardinalityHandler);
    setHandler(OWLComplementOf, pComplementOfHandler);
    setHandler(OWLDisjointWith, pDisjointWithHandler);
    setHandler(OWLEquivalentClass, pEquivalentClassHandler);
    setHandler(OWLIntersectionOf, pIntersectionOfHandler);
    setHandler(OWLMaxCardinality, pMaxCardinalityHandler);
    setHandler(OWLMinCardinality, pMinCardinalityHandler);
    setHandler(OWLOnProperty, pOnPropertyHandler);
    setHandler(OWLSomeValuesFrom, pSomeValuesFromHandler);
    setHandler(OWLVersionIRI, pVersionIRIHandler);
    
#define handlerNotImplemented(name) \
setHandler(name, pUnsupportedPredicateHandler)
    
    // Not implemented handlers
    handlerNotImplemented(RDFSComment);
    handlerNotImplemented(RDFSSubPropertyOf);
    handlerNotImplemented(OWLAnnotatedProperty);
    handlerNotImplemented(OWLAnnotatedSource);
    handlerNotImplemented(OWLAnnotatedTarget);
    handlerNotImplemented(OWLAssertionProperty);
    handlerNotImplemented(OWLDatatypeComplementOf);
    handlerNotImplemented(OWLDifferentFrom);
    handlerNotImplemented(OWLDisjointUnionOf);
    handlerNotImplemented(OWLDistinctMembers);
    handlerNotImplemented(OWLEquivalentProperty);
    handlerNotImplemented(OWLHasKey);
    handlerNotImplemented(OWLHasValue);
    handlerNotImplemented(OWLHasSelf);
    handlerNotImplemented(OWLImports);
    handlerNotImplemented(OWLInverseOf);
    handlerNotImplemented(OWLMaxQualifiedCardinality);
    handlerNotImplemented(OWLMembers);
    handlerNotImplemented(OWLMinQualifiedCardinality);
    handlerNotImplemented(OWLOnDatatype);
    handlerNotImplemented(OWLOnClass);
    handlerNotImplemented(OWLOnDataRange);
    handlerNotImplemented(OWLOneOf);
    handlerNotImplemented(OWLOnProperties);
    handlerNotImplemented(OWLOneOf);
    handlerNotImplemented(OWLPropertyChainAxiom);
    handlerNotImplemented(OWLPropertyDisjointWith);
    handlerNotImplemented(OWLQualifiedCardinality);
    handlerNotImplemented(OWLSameAs);
    handlerNotImplemented(OWLSourceIndividual);
    handlerNotImplemented(OWLTargetIndividual);
    handlerNotImplemented(OWLTargetValue);
    handlerNotImplemented(OWLUnionOf);
    handlerNotImplemented(OWLWithRestrictions);
    
    return map;
}

OWLStatementHandler handler_for_predicate(OWLMap *map, unsigned char *predicate)
{
    OWLStatementHandler handler = owl_map_get(map, predicate);
    
    if (!handler) {
        // If there's no handler for this predicate, it's a property assertion
        // or an annotation, though annotations are currently unsupported.
        handler = &pPropertyAssertionHandler;
    }
    
    return handler;
}
