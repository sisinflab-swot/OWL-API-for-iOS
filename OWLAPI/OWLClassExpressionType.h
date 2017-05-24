//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Represents the different types of OWL 2 class expressions.
typedef NS_ENUM(NSInteger, OWLClassExpressionType) {
    
#pragma mark - Class
    
    /// Represents OWLClass.
    OWLClassExpressionTypeClass,
    
#pragma mark - Object property restrictions
    
    /// Represents OWLObjectSomeValuesFrom.
    OWLClassExpressionTypeObjectSomeValuesFrom,
    
    /// Represents OWLObjectAllValuesFrom.
    OWLClassExpressionTypeObjectAllValuesFrom,
    
    /// Represents OWLObjectMinCardinality.
    OWLClassExpressionTypeObjectMinCardinality,
    
    /// Represents OWLObjectMaxCardinality.
    OWLClassExpressionTypeObjectMaxCardinality,
    
    /// Represents OWLObjectExactCardinality.
    OWLClassExpressionTypeObjectExactCardinality,
    
    /// Represents OWLObjectHasValue.
    OWLClassExpressionTypeObjectHasValue,
    
    /// Represents OWLObjectHasSelf.
    OWLClassExpressionTypeObjectHasSelf,
    
#pragma mark - Data property restrictions
    
    /// Represents OWLDataSomeValuesFrom.
    OWLClassExpressionTypeDataSomeValuesFrom,
    
    /// Represents OWLDataAllValuesFrom.
    OWLClassExpressionTypeDataAllValuesFrom,
    
    /// Represents OWLDataMaxCardinality.
    OWLClassExpressionTypeDataMaxCardinality,
    
    /// Represents OWLDataMinCardinality.
    OWLClassExpressionTypeDataMinCardinality,
    
    /// Represents OWLDataExactCardinality.
    OWLClassExpressionTypeDataExactCardinality,
    
    /// Represents OWLDataHasValue.
    OWLClassExpressionTypeDataHasValue,
    
#pragma mark - Boolean expressions
    
    /// Represents OWLObjectIntersectionOf.
    OWLClassExpressionTypeObjectIntersectionOf,
    
    /// Represents OWLObjectUnionOf.
    OWLClassExpressionTypeObjectUnionOf,
    
    /// Represents OWLObjectComplementOf.
    OWLClassExpressionTypeObjectComplementOf,
    
#pragma mark - Enumeration
    
    /// Represents OWLObjectOneOf.
    OWLClassExpressionTypeObjectOneOf
};
