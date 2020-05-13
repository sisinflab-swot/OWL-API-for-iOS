//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLAnonymousClassExpressionImpl.h"
#import "OWLObjectExactCardinality.h"
#import "OWLObjectMaxCardinality.h"
#import "OWLObjectMinCardinality.h"
#import "cowl_compat.h"

cowl_struct_decl(CowlObjCard);

NS_ASSUME_NONNULL_BEGIN

@interface OWLObjectCardinalityRestrictionImpl : OWLAnonymousClassExpressionImpl
<OWLObjectExactCardinality, OWLObjectMaxCardinality, OWLObjectMinCardinality>

- (instancetype)initWithCowlRestr:(CowlObjCard *)cowlRestr retain:(BOOL)retain;

- (instancetype)initExactCardinalityWithProperty:(id<OWLObjectPropertyExpression>)property
                                          filler:(id<OWLClassExpression>)filler
                                     cardinality:(NSUInteger)cardinality;

- (instancetype)initMaxCardinalityWithProperty:(id<OWLObjectPropertyExpression>)property
                                        filler:(id<OWLClassExpression>)filler
                                   cardinality:(NSUInteger)cardinality;

- (instancetype)initMinCardinalityWithProperty:(id<OWLObjectPropertyExpression>)property
                                        filler:(id<OWLClassExpression>)filler
                                   cardinality:(NSUInteger)cardinality;

@end

NS_ASSUME_NONNULL_END
