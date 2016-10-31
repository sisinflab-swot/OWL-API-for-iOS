//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLOntology.h"

@class OWLOntologyID;
@class OWLOntologyInternals;

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyImpl : OWLObjectImpl <OWLOntology>

- (instancetype)initWithID:(OWLOntologyID *)ID internals:(OWLOntologyInternals *)internals;

@end

NS_ASSUME_NONNULL_END
