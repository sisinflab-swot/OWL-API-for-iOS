//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Represents the type of axioms which can belong to ontologies.
typedef NS_ENUM(NSInteger, OWLAxiomType) {
    
#pragma mark - Declaration/definition
    
    /// Represents OWLDeclarationAxiom.
    OWLAxiomTypeDeclaration,
    
    /// Represents OWLDatatypeDefinitionAxiom.
    OWLAxiomTypeDatatypeDefinition,
    
#pragma mark - Class axioms
    
    /// Represents OWLEquivalentClassesAxiom.
    OWLAxiomTypeEquivalentClasses,
    
    /// Represents OWLSubClassOfAxiom.
    OWLAxiomTypeSubClassOf,
    
    /// Represents OWLDisjointClassesAxiom.
    OWLAxiomTypeDisjointClasses,
    
    /// Represents OWLDisjointUnionAxiom.
    OWLAxiomTypeDisjointUnion,

#pragma mark - Individual axioms
    
    /// Represents OWLClassAssertionAxiom.
    OWLAxiomTypeClassAssertion,
    
    /// Represents OWLSameIndividualAxiom.
    OWLAxiomTypeSameIndividual,
    
    /// Represents OWLDifferentIndividualsAxiom.
    OWLAxiomTypeDifferentIndividuals,
    
    /// Represents OWLObjectPropertyAssertionAxiom.
    OWLAxiomTypeObjectPropertyAssertion,
    
    /// Represents OWLNegativeObjectPropertyAssertionAxiom.
    OWLAxiomTypeNegativeObjectPropertyAssertion,
    
    /// Represents OWLDataPropertyAssertionAxiom.
    OWLAxiomTypeDataPropertyAssertion,
    
    /// Represents OWLNegativeDataPropertyAssertionAxiom.
    OWLAxiomTypeNegativeDataPropertyAssertion,

#pragma mark - Object property axioms
    
    /// Represents OWLEquivalentObjectPropertiesAxiom.
    OWLAxiomTypeEquivalentObjectProperties,
    
    /// Represents OWLSubObjectPropertyOfAxiom.
    OWLAxiomTypeSubObjectPropertyOf,
    
    /// Represents OWLInverseObjectPropertiesAxiom.
    OWLAxiomTypeInverseObjectProperties,
    
    /// Represents OWLFunctionalObjectPropertyAxiom.
    OWLAxiomTypeFunctionalObjectProperty,
    
    /// Represents OWLInverseFunctionalObjectPropertyAxiom.
    OWLAxiomTypeInverseFunctionalObjectProperty,
    
    /// Represents OWLSymmetricObjectPropertyAxiom.
    OWLAxiomTypeSymmetricObjectProperty,
    
    /// Represents OWLAsymmetricObjectPropertyAxiom.
    OWLAxiomTypeAsymmetricObjectProperty,
    
    /// Represents OWLTransitiveObjectPropertyAxiom.
    OWLAxiomTypeTransitiveObjectProperty,
    
    /// Represents OWLReflexiveObjectPropertyAxiom.
    OWLAxiomTypeReflexiveObjectProperty,
    
    /// Represents OWLIrreflexiveObjectPropertyAxiom.
    OWLAxiomTypeIrreflexiveObjectProperty,
    
    /// Represents OWLObjectPropertyDomainAxiom.
    OWLAxiomTypeObjectPropertyDomain,
    
    /// Represents OWLObjectPropertyRangeAxiom.
    OWLAxiomTypeObjectPropertyRange,
    
    /// Represents OWLDisjointObjectPropertiesAxiom.
    OWLAxiomTypeDisjointObjectProperties,
    
    /// Represents OWLSubPropertyChainOfAxiom.
    OWLAxiomTypeSubPropertyChainOf,

#pragma mark - Data property axioms
    
    /// Represents OWLEquivalentDataPropertiesAxiom.
    OWLAxiomTypeEquivalentDataProperties,
    
    /// Represents OWLSubDataPropertyOfAxiom.
    OWLAxiomTypeSubDataPropertyOf,
    
    /// Represents OWLFunctionalDataPropertyAxiom.
    OWLAxiomTypeFunctionalDataProperty,
    
    /// Represents OWLDataPropertyDomainAxiom.
    OWLAxiomTypeDataPropertyDomain,
    
    /// Represents OWLDataPropertyRangeAxiom.
    OWLAxiomTypeDataPropertyRange,
    
    /// Represents OWLDisjointDataPropertiesAxiom.
    OWLAxiomTypeDisjointDataProperties,
    
#pragma mark - Keys
    
    /// Represents OWLHasKeyAxiom.
    OWLAxiomTypeHasKey,
    
#pragma mark - Annotation axioms
    
    /// Represents OWLAnnotationAssertionAxiom.
    OWLAxiomTypeAnnotationAssertion,
    
    /// Represents OWLSubAnnotationPropertyOfAxiom.
    OWLAxiomTypeSubAnnotationPropertyOf,
    
    /// Represents OWLAnnotationPropertyRangeAxiom.
    OWLAxiomTypeAnnotationPropertyRange,
    
    /// Represents OWLAnnotationPropertyDomainAxiom.
    OWLAxiomTypeAnnotationPropertyDomain
};
