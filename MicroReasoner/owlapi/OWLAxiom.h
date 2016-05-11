//
//  OWLAxiom.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"
#import "OWLAxiomType.h"

@protocol OWLAxiom <OWLObject>

/// The axiom type for this axiom.
@property (nonatomic, readonly) OWLAxiomType axiomType;

@end
