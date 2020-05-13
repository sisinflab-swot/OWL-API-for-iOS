//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLDeclarationAxiom.h"
#import "cowl_compat.h"

cowl_struct_decl(CowlDeclAxiom);

NS_ASSUME_NONNULL_BEGIN

@interface OWLDeclarationAxiomImpl : OWLObjectImpl <OWLDeclarationAxiom>

- (instancetype)initWithCowlAxiom:(CowlDeclAxiom *)axiom retain:(BOOL)retain;
- (instancetype)initWithEntity:(id<OWLEntity>)entity;

@end

NS_ASSUME_NONNULL_END
