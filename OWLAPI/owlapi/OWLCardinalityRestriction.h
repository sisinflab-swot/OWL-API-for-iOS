//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLQuantifiedRestriction.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OWLCardinalityRestriction <OWLQuantifiedRestriction>

/// The cardinality of this restriction.
@property (nonatomic, readonly) NSUInteger cardinality;

/// Determines if this restriction is qualified.
@property (nonatomic, readonly) BOOL qualified;

@end

NS_ASSUME_NONNULL_END
