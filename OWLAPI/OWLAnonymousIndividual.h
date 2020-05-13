//
//  Created by Ivano Bilenchi on 25/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLIndividual.h"
#import "OWLNodeID.h"

NS_ASSUME_NONNULL_BEGIN

/// Represents Anonymous Individuals in the OWL 2 Specification.
@protocol OWLAnonymousIndividual <OWLIndividual>

/// The ID of this individual.
@property (nonatomic, readonly) OWLNodeID nodeID;

@end

NS_ASSUME_NONNULL_END
