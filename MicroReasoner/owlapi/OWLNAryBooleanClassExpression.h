//
//  OWLNAryBooleanClassExpression.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLBooleanClassExpression.h"

@protocol OWLClassExpression;

NS_ASSUME_NONNULL_BEGIN

@protocol OWLNAryBooleanClassExpression <OWLBooleanClassExpression>

@property (nonatomic, copy, readonly) NSSet<id<OWLClassExpression>> *operands;

@end

NS_ASSUME_NONNULL_END
