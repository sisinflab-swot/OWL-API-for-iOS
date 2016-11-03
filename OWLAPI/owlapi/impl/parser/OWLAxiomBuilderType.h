//
//  Created by Ivano Bilenchi on 18/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OWLABType) {
    OWLABTypeUnknown,
    OWLABTypeClassAssertion,
    OWLABTypeDeclaration,
    OWLABTypeDisjointClasses,
    OWLABTypeDomain,
    OWLABTypeEquivalentClasses,
    OWLABTypePropertyAssertion,
    OWLABTypeRange,
    OWLABTypeSubClassOf,
    OWLABTypeTransitiveProperty
};

typedef NS_ENUM(NSInteger, OWLABDeclType) {
    OWLABDeclTypeUnknown,
    OWLABDeclTypeClass,
    OWLABDeclTypeObjectProperty,
    OWLABDeclTypeNamedIndividual
};