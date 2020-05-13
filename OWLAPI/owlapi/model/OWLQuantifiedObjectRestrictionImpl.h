//
//  Created by Ivano Bilenchi on 07/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLAnonymousClassExpressionImpl.h"
#import "OWLObjectAllValuesFrom.h"
#import "OWLObjectSomeValuesFrom.h"
#import "OWLObjectPropertyExpression.h"
#import "cowl_compat.h"

cowl_struct_decl(CowlObjQuant);

@protocol OWLObjectPropertyExpression;

NS_ASSUME_NONNULL_BEGIN

@interface OWLQuantifiedObjectRestrictionImpl : OWLAnonymousClassExpressionImpl
<OWLObjectAllValuesFrom, OWLObjectSomeValuesFrom>

- (instancetype)initWithCowlClsExp:(CowlObjQuant *)exp retain:(BOOL)retain;
- (instancetype)initExsistentialWithProperty:(id<OWLObjectPropertyExpression>)property
                                      filler:(id<OWLClassExpression>)filler;
- (instancetype)initUniversalWithProperty:(id<OWLObjectPropertyExpression>)property
                                   filler:(id<OWLClassExpression>)filler;

@end

NS_ASSUME_NONNULL_END
