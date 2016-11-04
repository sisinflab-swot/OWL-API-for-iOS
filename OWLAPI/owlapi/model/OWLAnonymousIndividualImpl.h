//
//  Created by Ivano Bilenchi on 25/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLIndividualImpl.h"
#import "OWLAnonymousIndividual.h"

NS_ASSUME_NONNULL_BEGIN

@interface OWLAnonymousIndividualImpl : OWLIndividualImpl <OWLAnonymousIndividual>

- (instancetype)initWithNodeID:(OWLNodeID)ID;

@end

NS_ASSUME_NONNULL_END
