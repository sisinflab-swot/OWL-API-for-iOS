//
//  OWLObjectCardinalityRestriction.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLCardinalityRestriction.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OWLObjectCardinalityRestriction <OWLCardinalityRestriction>

@property (nonatomic, strong, readonly) id<OWLClassExpression> filler;

@end

NS_ASSUME_NONNULL_END
