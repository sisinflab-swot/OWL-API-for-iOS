//
//  SMRPreprocessor.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#ifndef SMRPreprocessor_h
#define SMRPreprocessor_h

// Pseudo-abstract class convenience macros.

#define ABSTRACT_METHOD {\
@throw [NSException exceptionWithName:NSInternalInconsistencyException \
reason:@"This method should be overridden in a subclass." \
userInfo:nil]; \
}

#endif /* SMRPreprocessor_h */
