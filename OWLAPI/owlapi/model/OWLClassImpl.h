//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLClassImpl : OWLObjectImpl <OWLClass>

- (instancetype)initWithIRI:(OWLIRI *)IRI;

@end

NS_ASSUME_NONNULL_END
