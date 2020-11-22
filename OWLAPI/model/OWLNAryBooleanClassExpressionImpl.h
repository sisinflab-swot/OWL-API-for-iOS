//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLAnonymousClassExpressionImpl.h"
#import "OWLObjectIntersectionOf.h"

#import <cowl_compat.h>

cowl_struct_decl(CowlNAryBool);

NS_ASSUME_NONNULL_BEGIN

@interface OWLNAryBooleanClassExpressionImpl : OWLAnonymousClassExpressionImpl <OWLObjectIntersectionOf>

- (instancetype)initWithCowlClsExp:(CowlNAryBool *)exp retain:(BOOL)retain;
- (instancetype)initIntersection:(NSSet<id<OWLClassExpression>> *)operands;
- (instancetype)initUnion:(NSSet<id<OWLClassExpression>> *)operands;

@end

NS_ASSUME_NONNULL_END
