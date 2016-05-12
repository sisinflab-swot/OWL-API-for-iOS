//
//  OWLPropertyRangeAxiom.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLUnaryPropertyAxiom.h"

@protocol OWLPropertyRange;

NS_ASSUME_NONNULL_BEGIN

@protocol OWLPropertyRangeAxiom <OWLUnaryPropertyAxiom>

/// The range specified by this axiom.
@property (nonatomic, copy, readonly) id<OWLPropertyRange> range;

@end

NS_ASSUME_NONNULL_END
