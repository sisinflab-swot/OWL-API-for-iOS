//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLNamedIndividual.h"
#import "cowl_compat.h"

cowl_struct_decl(CowlNamedInd);

NS_ASSUME_NONNULL_BEGIN

@interface OWLNamedIndividualImpl : OWLObjectImpl <OWLNamedIndividual>

- (instancetype)initWithCowlNamedInd:(CowlNamedInd *)cowlInd retain:(BOOL)retain;
- (instancetype)initWithIRI:(OWLIRI *)IRI;

@end

NS_ASSUME_NONNULL_END
