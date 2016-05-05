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
[self doesNotRecognizeSelector:_cmd]; \
__builtin_unreachable(); \
}

#endif /* SMRPreprocessor_h */
