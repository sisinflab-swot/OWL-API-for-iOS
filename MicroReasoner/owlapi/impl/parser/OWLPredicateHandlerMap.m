//
//  OWLPredicateHandlerMap.m
//  MicroReasoner
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
#import "OWLOntologyBuilder.h"
#import "OWLPropertyBuilder.h"
#import "OWLRDFTypeHandlerMap.h"
#import "OWLRDFVocabulary.h"
#import "RDFNode.h"
#import "RDFStatement.h"
#import "SMRPreprocessor.h"

@interface OWLPredicateHandlerMap ()
{
    NSDictionary *_handlers;
}
@end


@implementation OWLPredicateHandlerMap

NS_INLINE NSDictionary * initHandlers()
{
    NSMutableDictionary<NSString *, OWLStatementHandler> *map = [[NSMutableDictionary alloc] init];
    
    map[[OWLRDFVocabulary RDFFirst].stringValue] = [pRDFFirstHandler copy];
    map[[OWLRDFVocabulary RDFRest].stringValue] = [pRDFRestHandler copy];
    map[[OWLRDFVocabulary RDFType].stringValue] = [pRDFTypeHandler copy];
    map[[OWLRDFVocabulary RDFSDomain].stringValue] = [pDomainHandler copy];
    map[[OWLRDFVocabulary RDFSRange].stringValue] = [pRangeHandler copy];
    map[[OWLRDFVocabulary RDFSSubClassOf].stringValue] = [pSubClassOfHandler copy];
    map[[OWLRDFVocabulary OWLAllValuesFrom].stringValue] = [pAllValuesFromHandler copy];
    map[[OWLRDFVocabulary OWLCardinality].stringValue] = [pCardinalityHandler copy];
    map[[OWLRDFVocabulary OWLDisjointWith].stringValue] = [pDisjointWithHandler copy];
    map[[OWLRDFVocabulary OWLEquivalentClass].stringValue] = [pEquivalentClassHandler copy];
    map[[OWLRDFVocabulary OWLIntersectionOf].stringValue] = [pIntersectionOfHandler copy];
    map[[OWLRDFVocabulary OWLMaxCardinality].stringValue] = [pMaxCardinalityHandler copy];
    map[[OWLRDFVocabulary OWLMinCardinality].stringValue] = [pMinCardinalityHandler copy];
    map[[OWLRDFVocabulary OWLOnProperty].stringValue] = [pOnPropertyHandler copy];
    map[[OWLRDFVocabulary OWLSomeValuesFrom].stringValue] = [pSomeValuesFromHandler copy];
    map[[OWLRDFVocabulary OWLVersionIRI].stringValue] = [pVersionIRIHandler copy];
    
    OWLStatementHandler notImplemented = [pUnsupportedPredicateHandler copy];
    
#define handlerNotImplemented(name) \
map[[OWLRDFVocabulary name].stringValue] = notImplemented
    
    // Not implemented handlers
    handlerNotImplemented(RDFSComment);
    handlerNotImplemented(RDFSSubPropertyOf);
    handlerNotImplemented(OWLAnnotatedProperty);
    handlerNotImplemented(OWLAnnotatedSource);
    handlerNotImplemented(OWLAnnotatedTarget);
    handlerNotImplemented(OWLAssertionProperty);
    handlerNotImplemented(OWLComplementOf);
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
    OWLStatementHandler handler = _handlers[signature];
    
    if (!handler) {
        // If there's no handler for this predicate, it's a property assertion
        // or an annotation, though annotations are currently unsupported.
        handler = pPropertyAssertionHandler;
    }
    
    return handler;
}

#pragma mark Unsupported predicate handler

OWLStatementHandler pUnsupportedPredicateHandler = ^BOOL(RDFStatement *statement, __unused OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Unsupported predicate in statement."
                                  userInfo:@{@"statement": statement}];
    }
    return NO;
};

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
        NSString *subjectID = namedIndividual ? subject.URIStringValue : subject.blankID;
        
        OWLIndividualBuilder *ib = [builder ensureIndividualBuilderForID:subjectID];
        
        if (![ib setType:(namedIndividual ? OWLIBTypeNamed : OWLIBTypeAnonymous) error:&localError]) {
            goto err;
        }
        
        if (![ib setID:subjectID error:&localError]) {
            goto err;
        }
        
        // Add class expression
        NSString *objectID = (named ? statement.object.URIStringValue : statement.object.blankID);
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:objectID];
        
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

OWLStatementHandler pRDFTypeHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    static id<OWLStatementHandlerMap> objectHandlerMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objectHandlerMap = [[OWLRDFTypeHandlerMap alloc] init];
    });
    
    NSError *__autoreleasing localError = nil;
    RDFNode *object = statement.object;
    
    if (object.isResource) {
        
        NSString *objectID = object.URIStringValue;
        OWLStatementHandler handler = [objectHandlerMap handlerForSignature:objectID];
        
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

#pragma mark Property assertion handler

OWLStatementHandler pPropertyAssertionHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
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
        NSString *subjectID = subject.isResource ? subject.URIStringValue : subject.blankID;
        NSString *predicateID = predicate.URIStringValue;
        NSString *objectID = object.isResource ? object.URIStringValue : object.blankID;
        
        OWLAxiomBuilder *ab = [builder addSingleStatementAxiomBuilderForID:subjectID];
        
        if (![ab setType:OWLABTypePropertyAssertion error:&localError]) {
            goto err;
        }
        
        if (![ab setLHSID:subjectID error:&localError]) {
            goto err;
        }
        
        if (![ab setMID:predicateID error:&localError]) {
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
};

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
        NSString *subjectID = subject.blankID;
        NSString *objectID = object.isResource ? object.URIStringValue : object.blankID;
        
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

OWLStatementHandler pRDFFirstHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleListStatement(statement, builder, YES, error);
};

OWLStatementHandler pRDFRestHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleListStatement(statement, builder, NO, error);
};

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
        NSString *fillerID = objectIsResource ? object.URIStringValue : object.blankID;
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:fillerID];
        
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

OWLStatementHandler pAllValuesFromHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleQuantificationStatement(statement, builder, YES, error);
};

OWLStatementHandler pSomeValuesFromHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleQuantificationStatement(statement, builder, NO, error);
};

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
        NSString *subjectID = subject.blankID;
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

OWLStatementHandler pCardinalityHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleCardinalityStatement(statement, builder, OWLCEBRestrictionTypeCardinality, error);
};

OWLStatementHandler pMinCardinalityHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleCardinalityStatement(statement, builder, OWLCEBRestrictionTypeMinCardinality, error);
};

OWLStatementHandler pMaxCardinalityHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleCardinalityStatement(statement, builder, OWLCEBRestrictionTypeMaxCardinality, error);
};

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
        if (object.isBlank && !object.blankID) {
            
        }
        // LHS class expression
        BOOL isResource = subject.isResource;
        NSString *LHSClassID = isResource ? subject.URIStringValue : subject.blankID;
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:LHSClassID];
        
        if (isResource) {
            if (![ceb setType:OWLCEBTypeClass error:&localError]) {
                goto err;
            }
            
            if (![ceb setClassID:LHSClassID error:&localError]) {
                goto err;
            }
        }
        
        // RHS class expression
        isResource = object.isResource;
        NSString *RHSClassID = isResource ? object.URIStringValue : object.blankID;
        
        ceb = [builder ensureClassExpressionBuilderForID:RHSClassID];
        
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

OWLStatementHandler pDisjointWithHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleBinaryCEAxiomStatement(statement, builder, OWLABTypeDisjointClasses, error);
};

OWLStatementHandler pEquivalentClassHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleBinaryCEAxiomStatement(statement, builder, OWLABTypeEquivalentClasses, error);
};

OWLStatementHandler pSubClassOfHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleBinaryCEAxiomStatement(statement, builder, OWLABTypeSubClassOf, error);
};

#pragma mark owl:intersectionOf predicate handler

OWLStatementHandler pIntersectionOfHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
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

OWLStatementHandler pOnPropertyHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
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
        NSString *objectID = object.URIStringValue;
        OWLPropertyBuilder *pb = [builder ensurePropertyBuilderForID:objectID];
        
        if (![pb setType:OWLPBTypeObjectProperty error:&localError]) {
            goto err;
        }
        
        if (![pb setNamedPropertyID:objectID error:NULL]) {
            goto err;
        }
        
        // Add class expression builder
        NSString *subjectID = subject.blankID;
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
};

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
        NSString *subjectID = subject.isResource ? subject.URIStringValue : subject.blankID;
        OWLPropertyBuilder *pb = [builder ensurePropertyBuilderForID:subjectID];
        
        if (![pb setType:OWLPBTypeObjectProperty error:&localError]) {
            goto err;
        }
        
        if (![pb setNamedPropertyID:subjectID error:&localError]) {
            goto err;
        }
        
        // Add class expression builder
        BOOL objectIsResource = object.isResource;
        NSString *objectID = objectIsResource ? object.URIStringValue : object.blankID;
        
        OWLClassExpressionBuilder *ceb = [builder ensureClassExpressionBuilderForID:objectID];
        
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
        if (!ab) {
            localError = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                              localizedDescription:@"Multiple domain/range axioms for same property expression."
                                          userInfo:@{@"statement": statement}];
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

OWLStatementHandler pDomainHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleDomainRangeStatement(statement, builder, YES, error);
};

OWLStatementHandler pRangeHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
{
    return handleDomainRangeStatement(statement, builder, NO, error);
};

#pragma mark Ontology version IRI handler

OWLStatementHandler pVersionIRIHandler = ^BOOL(RDFStatement *statement, OWLOntologyBuilder *builder, NSError *__autoreleasing *error)
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
        NSString *subjectIRI = subject.URIStringValue;
        NSString *objectIRI = object.URIStringValue;
        
        if (![builder setOntologyIRI:subjectIRI error:&localError]) {
            goto err;
        }
        
        if (![builder setVersionIRI:objectIRI error:&localError]) {
            goto err;
        }
    }
    
err:
    if (error) {
        *error = localError;
    }
    
    return !localError;
};

@end
