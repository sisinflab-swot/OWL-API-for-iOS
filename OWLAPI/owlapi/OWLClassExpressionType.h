//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Represents the different types of OWL 2 class expressions.
typedef NS_ENUM(NSInteger, OWLClassExpressionType) {
    OWLClassExpTypeClass,
    OWLClassExpTypeObjectSomeValuesFrom,
    OWLClassExpTypeObjectAllValuesFrom,
    OWLClassExpTypeObjectMinCardinality,
    OWLClassExpTypeObjectMaxCardinality,
    OWLClassExpTypeObjectExactCardinality,
    OWLClassExpTypeObjectHasValue,
    OWLClassExpTypeObjectHasSelf,
    OWLClassExpTypeDataSomeValuesFrom,
    OWLClassExpTypeDataAllValuesFrom,
    OWLClassExpTypeDataMaxCardinality,
    OWLClassExpTypeDataMinCardinality,
    OWLClassExpTypeDataExactCardinality,
    OWLClassExpTypeDataHasValue,
    OWLClassExpTypeObjectIntersectionOf,
    OWLClassExpTypeObjectUnionOf,
    OWLClassExpTypeObjectComplementOf,
    OWLClassExpTypeObjectOneOf
};
