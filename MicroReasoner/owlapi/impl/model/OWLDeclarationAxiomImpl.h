//
//  OWLDeclarationAxiomImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLDeclarationAxiom.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLDeclarationAxiomImpl : OWLObjectImpl <OWLDeclarationAxiom>

- (instancetype)initWithEntity:(id<OWLEntity>)entity;

@end

NS_ASSUME_NONNULL_END
