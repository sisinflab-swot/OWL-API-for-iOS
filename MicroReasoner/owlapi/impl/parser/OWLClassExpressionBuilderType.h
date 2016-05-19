//
//  OWLClassExpressionBuilderType.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 18/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OWLCEBType) {
    OWLCEBTypeUnknown,
    OWLCEBTypeClass,
    OWLCEBTypeBoolean,
    OWLCEBTypeRestriction
};

typedef NS_ENUM(NSInteger, OWLCEBRestrictionType) {
    OWLCEBRestrictionTypeUnknown,
    OWLCEBRestrictionTypeAllValuesFrom,
    OWLCEBRestrictionTypeSomeValuesFrom,
    OWLCEBRestrictionTypeCardinality,
    OWLCEBRestrictionTypeMaxCardinality,
    OWLCEBRestrictionTypeMinCardinality
};
