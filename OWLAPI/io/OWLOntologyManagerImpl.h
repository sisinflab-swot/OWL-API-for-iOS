//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntologyManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyManagerImpl : NSObject <OWLOntologyManager>

- (instancetype)initWithDataFactory:(id<OWLDataFactory>)dataFactory;

@end

NS_ASSUME_NONNULL_END
