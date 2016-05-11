//
//  OWLAxiom.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"
#import "OWLAxiomType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OWLAxiom <OWLObject>

/// The axiom type for this axiom.
@property (nonatomic, readonly) OWLAxiomType axiomType;

/// Determines if this axiom is an annotation axiom.
@property (nonatomic, readonly) BOOL isAnnotationAxiom;

/// Determines if this axiom is a logical axiom.
@property (nonatomic, readonly) BOOL isLogicalAxiom;

@end

NS_ASSUME_NONNULL_END
