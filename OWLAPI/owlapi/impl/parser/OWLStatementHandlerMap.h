//
//  Created by Ivano Bilenchi on 21/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDFStatement;
@class OWLOntologyBuilder;

NS_ASSUME_NONNULL_BEGIN

/// Represents the handler of a RDF triple.
typedef BOOL (^OWLStatementHandler)(RDFStatement *, OWLOntologyBuilder *, NSError *_Nullable __autoreleasing *);

/// Maps statement signatures to their respective handlers.
@protocol OWLStatementHandlerMap <NSObject>

/**
 * Get the statement handler for a specific signature.
 *
 * @param signature The signature of the statement.
 *
 * @return An appropriate handler for the specified statement signature.
 */
- (nullable OWLStatementHandler)handlerForSignature:(NSString *)signature;

@end

NS_ASSUME_NONNULL_END
