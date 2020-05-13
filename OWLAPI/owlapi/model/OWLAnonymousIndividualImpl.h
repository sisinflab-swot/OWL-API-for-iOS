//
//  Created by Ivano Bilenchi on 25/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLAnonymousIndividual.h"
#import "cowl_compat.h"

cowl_struct_decl(CowlAnonInd);

NS_ASSUME_NONNULL_BEGIN

@interface OWLAnonymousIndividualImpl : OWLObjectImpl <OWLAnonymousIndividual>

- (instancetype)initWithCowlIndividual:(CowlAnonInd *)cowlInd retain:(BOOL)retain;
- (instancetype)initWithNodeID:(OWLNodeID)nodeID;

@end

NS_ASSUME_NONNULL_END
