//
//  OWLQuantifiedRestriction.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLRestriction.h"

@protocol OWLPropertyRange;

NS_ASSUME_NONNULL_BEGIN

@protocol OWLQuantifiedRestriction <OWLRestriction>

@property (nonatomic, strong, readonly) id<OWLPropertyRange> filler;

@end

NS_ASSUME_NONNULL_END
