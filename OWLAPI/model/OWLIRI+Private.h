//
//  Created by Ivano Bilenchi on 10/05/2020.
//  Copyright © 2020 SisInf Lab. All rights reserved.
//

#import "OWLIRI.h"

#import <cowl_compat.h>

cowl_struct_decl(CowlIRI);

NS_ASSUME_NONNULL_BEGIN

@interface OWLIRI ()

@property (nonatomic, readonly) CowlIRI *cowlIRI;

- (instancetype)initWithCowlIRI:(CowlIRI *)cowlIRI retain:(BOOL)retain;

@end

NS_ASSUME_NONNULL_END
