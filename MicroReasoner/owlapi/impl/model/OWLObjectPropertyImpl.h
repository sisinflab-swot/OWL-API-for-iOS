//
//  OWLObjectPropertyImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 08/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyExpressionImpl.h"
#import "OWLObjectProperty.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLObjectPropertyImpl : OWLObjectPropertyExpressionImpl <OWLObjectProperty>

- (instancetype)initWithIRI:(NSURL *)IRI;

@end

NS_ASSUME_NONNULL_END
