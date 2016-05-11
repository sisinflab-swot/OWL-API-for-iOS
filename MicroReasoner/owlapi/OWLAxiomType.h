//
//  OWLAxiomType.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Represents the type of axioms which can belong to ontologies.
typedef NS_ENUM(NSInteger, OWLAxiomType) {
    // Declaration/definition
    OWLAxiomTypeDeclaration,
    OWLAxiomTypeDataTypeDefinition,
    // Class axioms
    OWLAxiomTypeEquivalentClasses,
    OWLAxiomTypeSubClassOf,
    OWLAxiomTypeDisjointClasses,
    OWLAxiomTypeDisjointUnion,
    // Individual axioms
    OWLAxiomTypeClassAssertion,
    OWLAxiomTypeSameIndividual,
    OWLAxiomTypeDifferentIndividuals,
    OWLAxiomTypeObjectPropertyAssertion,
    OWLAxiomTypeNegativeObjectPropertyAssertion,
    OWLAxiomTypeDataPropertyAssertion,
    OWLAxiomTypeNegativeDataPropertyAssertion,
    // Object property axioms
    OWLAxiomTypeEquivalentObjectProperties,
    OWLAxiomTypeSubObjectProperty,
    OWLAxiomTypeInverseObjectProperty,
    OWLAxiomTypeFunctionalObjectProperty,
    OWLAxiomTypeInverseFunctionalObjectProperty,
    OWLAxiomTypeSymmetricObjectProperty,
    OWLAxiomTypeAsymmetricObjectProperty,
    OWLAxiomTypeTransitiveObjectProperty,
    OWLAxiomTypeReflexiveObjectProperty,
    OWLAxiomTypeIrreflexiveObjectProperty,
    OWLAxiomTypeObjectPropertyDomain,
    OWLAxiomTypeObjectPropertyRange,
    OWLAxiomTypeDisjointObjectProperties,
    OWLAxiomTypeSubPropertyChain,
    // Data property axioms
    OWLAxiomTypeEquivalentDataProperties,
    OWLAxiomTypeSubDataProperty,
    OWLAxiomTypeFunctionalDataProperty,
    OWLAxiomTypeDataPropertyDomain,
    OWLAxiomTypeDataPropertyRange,
    OWLAxiomTypeDisjointDataProperties,
    // Other property axioms
    OWLAxiomTypeHasKey,
    // Annotation axioms
    OWLAxiomTypeAnnotationAssertion,
    OWLAxiomTypeSubAnnotationPropertyOf,
    OWLAxiomTypeAnnotationPropertyRange,
    OWLAxiomTypeAnnotationPropertyDomain
};
