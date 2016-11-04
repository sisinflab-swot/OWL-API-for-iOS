//
//  Created by Ivano Bilenchi on 15/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLIndividualImpl.h"
#import "OWLNamedIndividual.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLNamedIndividualImpl : OWLIndividualImpl <OWLNamedIndividual>

- (instancetype)initWithIRI:(NSURL *)IRI;

@end

NS_ASSUME_NONNULL_END
