//
//  Created by Ivano Bilenchi on 08/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectPropertyExpressionImpl.h"
#import "OWLObjectProperty.h"
#import "cowl_compat.h"

cowl_struct_decl(CowlObjProp);

NS_ASSUME_NONNULL_BEGIN

@interface OWLObjectPropertyImpl : OWLObjectPropertyExpressionImpl <OWLObjectProperty>

- (instancetype)initWithCowlProperty:(CowlObjProp *)cowlProp retain:(BOOL)retain;
- (instancetype)initWithIRI:(OWLIRI *)IRI;

@end

NS_ASSUME_NONNULL_END
