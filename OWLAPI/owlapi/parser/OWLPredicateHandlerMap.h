//
//  Created by Ivano Bilenchi on 21/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLStatementHandler.h"
#import "OWLMap.h"

NS_ASSUME_NONNULL_BEGIN

extern OWLMap *predicateHandlerMap;

extern OWLMap * init_predicate_handlers(void);

extern OWLStatementHandler _Nullable handler_for_predicate(OWLMap *map, unsigned char *predicate);

NS_ASSUME_NONNULL_END
