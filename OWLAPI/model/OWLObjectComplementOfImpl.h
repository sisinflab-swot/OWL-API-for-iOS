//
//  Created by Ivano Bilenchi on 22/09/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLAnonymousClassExpressionImpl.h"
#import "OWLObjectComplementOf.h"

#import <cowl_compat.h>

cowl_struct_decl(CowlObjCompl);

NS_ASSUME_NONNULL_BEGIN

@interface OWLObjectComplementOfImpl : OWLAnonymousClassExpressionImpl <OWLObjectComplementOf>

- (instancetype)initWithCowlClsExp:(CowlObjCompl *)exp retain:(BOOL)retain;
- (instancetype)initWithOperand:(id<OWLClassExpression>)operand;

@end

NS_ASSUME_NONNULL_END
