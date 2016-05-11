//
//  OWLLogicalAxiomImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 11/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLLogicalAxiom.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLLogicalAxiom protocol.
@interface OWLLogicalAxiomImpl : OWLObjectImpl

#pragma mark OWLAxiom

@property (nonatomic, readonly) BOOL isAnnotationAxiom;
@property (nonatomic, readonly) BOOL isLogicalAxiom;

@end

NS_ASSUME_NONNULL_END
