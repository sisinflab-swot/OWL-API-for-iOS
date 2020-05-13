//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Represents the type of axioms which can belong to ontologies.
typedef NS_OPTIONS(uint64_t, OWLAxiomType) {
    
#pragma mark - Declaration/definition
    
    /// Represents OWLDeclarationAxiom.
    OWLAxiomTypeDeclaration                             = (uint64_t)1 << 0,
    
    /// Represents OWLDatatypeDefinitionAxiom.
    OWLAxiomTypeDatatypeDefinition                      = (uint64_t)1 << 1,
    
#pragma mark - Class axioms
    
    /// Represents OWLEquivalentClassesAxiom.
    OWLAxiomTypeEquivalentClasses                       = (uint64_t)1 << 2,
    
    /// Represents OWLSubClassOfAxiom.
    OWLAxiomTypeSubClassOf                              = (uint64_t)1 << 3,
    
    /// Represents OWLDisjointClassesAxiom.
    OWLAxiomTypeDisjointClasses                         = (uint64_t)1 << 4,
    
    /// Represents OWLDisjointUnionAxiom.
    OWLAxiomTypeDisjointUnion                           = (uint64_t)1 << 5,

#pragma mark - Individual axioms
    
    /// Represents OWLClassAssertionAxiom.
    OWLAxiomTypeClassAssertion                          = (uint64_t)1 << 6,
    
    /// Represents OWLSameIndividualAxiom.
    OWLAxiomTypeSameIndividual                          = (uint64_t)1 << 7,
    
    /// Represents OWLDifferentIndividualsAxiom.
    OWLAxiomTypeDifferentIndividuals                    = (uint64_t)1 << 8,
    
    /// Represents OWLObjectPropertyAssertionAxiom.
    OWLAxiomTypeObjectPropertyAssertion                 = (uint64_t)1 << 9,
    
    /// Represents OWLNegativeObjectPropertyAssertionAxiom.
    OWLAxiomTypeNegativeObjectPropertyAssertion         = (uint64_t)1 << 10,
    
    /// Represents OWLDataPropertyAssertionAxiom.
    OWLAxiomTypeDataPropertyAssertion                   = (uint64_t)1 << 11,
    
    /// Represents OWLNegativeDataPropertyAssertionAxiom.
    OWLAxiomTypeNegativeDataPropertyAssertion           = (uint64_t)1 << 12,

#pragma mark - Object property axioms
    
    /// Represents OWLEquivalentObjectPropertiesAxiom.
    OWLAxiomTypeEquivalentObjectProperties              = (uint64_t)1 << 13,
    
    /// Represents OWLSubObjectPropertyOfAxiom.
    OWLAxiomTypeSubObjectPropertyOf                     = (uint64_t)1 << 14,
    
    /// Represents OWLInverseObjectPropertiesAxiom.
    OWLAxiomTypeInverseObjectProperties                 = (uint64_t)1 << 15,
    
    /// Represents OWLFunctionalObjectPropertyAxiom.
    OWLAxiomTypeFunctionalObjectProperty                = (uint64_t)1 << 16,
    
    /// Represents OWLInverseFunctionalObjectPropertyAxiom.
    OWLAxiomTypeInverseFunctionalObjectProperty         = (uint64_t)1 << 17,
    
    /// Represents OWLSymmetricObjectPropertyAxiom.
    OWLAxiomTypeSymmetricObjectProperty                 = (uint64_t)1 << 18,
    
    /// Represents OWLAsymmetricObjectPropertyAxiom.
    OWLAxiomTypeAsymmetricObjectProperty                = (uint64_t)1 << 19,
    
    /// Represents OWLTransitiveObjectPropertyAxiom.
    OWLAxiomTypeTransitiveObjectProperty                = (uint64_t)1 << 20,
    
    /// Represents OWLReflexiveObjectPropertyAxiom.
    OWLAxiomTypeReflexiveObjectProperty                 = (uint64_t)1 << 21,
    
    /// Represents OWLIrreflexiveObjectPropertyAxiom.
    OWLAxiomTypeIrreflexiveObjectProperty               = (uint64_t)1 << 22,
    
    /// Represents OWLObjectPropertyDomainAxiom.
    OWLAxiomTypeObjectPropertyDomain                    = (uint64_t)1 << 23,
    
    /// Represents OWLObjectPropertyRangeAxiom.
    OWLAxiomTypeObjectPropertyRange                     = (uint64_t)1 << 24,
    
    /// Represents OWLDisjointObjectPropertiesAxiom.
    OWLAxiomTypeDisjointObjectProperties                = (uint64_t)1 << 25,
    
    /// Represents OWLSubPropertyChainOfAxiom.
    OWLAxiomTypeSubPropertyChainOf                      = (uint64_t)1 << 26,

#pragma mark - Data property axioms
    
    /// Represents OWLEquivalentDataPropertiesAxiom.
    OWLAxiomTypeEquivalentDataProperties                = (uint64_t)1 << 27,
    
    /// Represents OWLSubDataPropertyOfAxiom.
    OWLAxiomTypeSubDataPropertyOf                       = (uint64_t)1 << 28,
    
    /// Represents OWLFunctionalDataPropertyAxiom.
    OWLAxiomTypeFunctionalDataProperty                  = (uint64_t)1 << 29,
    
    /// Represents OWLDataPropertyDomainAxiom.
    OWLAxiomTypeDataPropertyDomain                      = (uint64_t)1 << 30,
    
    /// Represents OWLDataPropertyRangeAxiom.
    OWLAxiomTypeDataPropertyRange                       = (uint64_t)1 << 31,
    
    /// Represents OWLDisjointDataPropertiesAxiom.
    OWLAxiomTypeDisjointDataProperties                  = (uint64_t)1 << 32,
    
#pragma mark - Keys
    
    /// Represents OWLHasKeyAxiom.
    OWLAxiomTypeHasKey                                  = (uint64_t)1 << 33,
    
#pragma mark - Annotation axioms
    
    /// Represents OWLAnnotationAssertionAxiom.
    OWLAxiomTypeAnnotationAssertion                     = (uint64_t)1 << 34,
    
    /// Represents OWLSubAnnotationPropertyOfAxiom.
    OWLAxiomTypeSubAnnotationPropertyOf                 = (uint64_t)1 << 35,
    
    /// Represents OWLAnnotationPropertyRangeAxiom.
    OWLAxiomTypeAnnotationPropertyRange                 = (uint64_t)1 << 36,
    
    /// Represents OWLAnnotationPropertyDomainAxiom.
    OWLAxiomTypeAnnotationPropertyDomain                = (uint64_t)1 << 37,
    
#pragma mark - Markers
    
    /// Represents all axiom types.
    OWLAxiomTypeAll                                     = (uint64_t)-1,

    /// First axiom type.
    OWLAxiomTypeFirst                                   = OWLAxiomTypeDeclaration,

    /// Last axiom type.
    OWLAxiomTypeLast                                    = OWLAxiomTypeAnnotationPropertyDomain
};
