//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLClass.h"
#import "OWLIdentifiedEntity.h"
#import "cowl_compat.h"

cowl_struct_decl(CowlClass);

NS_ASSUME_NONNULL_BEGIN

@interface OWLClassImpl : OWLObjectImpl <OWLClass, OWLIdentifiedEntity>

- (instancetype)initWithCowlClass:(CowlClass *)cowlClass retain:(BOOL)retain;
- (instancetype)initWithIRI:(OWLIRI *)iri;

@end

NS_ASSUME_NONNULL_END
