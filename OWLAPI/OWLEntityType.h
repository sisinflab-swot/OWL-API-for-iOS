//
//  Created by Ivano Bilenchi on 13/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Represents the different types of OWL 2 Entities.
typedef NS_ENUM(NSInteger, OWLEntityType) {
    
    /// Represents OWLClass.
    OWLEntityTypeClass,
    
    /// Represents OWLObjectProperty.
    OWLEntityTypeObjectProperty,
    
    /// Represents OWLDataProperty.
    OWLEntityTypeDataProperty,
    
    /// Represents OWLAnnotationProperty.
    OWLEntityTypeAnnotationProperty,
    
    /// Represents OWLNamedIndividual.
    OWLEntityTypeNamedIndividual,
    
    /// Represents OWLDatatype.
    OWLEntityTypeDatatype
};
