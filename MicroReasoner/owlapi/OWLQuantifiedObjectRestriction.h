//
//  OWLQuantifiedObjectRestriction.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 06/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLQuantifiedRestriction.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OWLQuantifiedObjectRestriction <OWLQuantifiedRestriction>

@property (nonatomic, strong, readonly) id<OWLClassExpression> filler;

@end

NS_ASSUME_NONNULL_END
