//
//  Created by Ivano Bilenchi on 21/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDFStatement;
@class OWLOntologyBuilder;

NS_ASSUME_NONNULL_BEGIN

/// Represents the handler of a RDF triple.
typedef BOOL (*OWLStatementHandler)(RDFStatement *, OWLOntologyBuilder *, NSError *_Nullable __autoreleasing *);

NS_ASSUME_NONNULL_END
