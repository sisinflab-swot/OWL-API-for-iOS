//
//  RDFStatement.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 23/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RDFNode;

NS_ASSUME_NONNULL_BEGIN

/// Represents RDF statements (triples).
@interface RDFStatement : NSObject

/// The subject of this statement.
@property (nonatomic, strong, readonly) RDFNode *subject;

/// The predicate of this statement.
@property (nonatomic, strong, readonly) RDFNode *predicate;

/// The object of this statement.
@property (nonatomic, strong, readonly) RDFNode *object;

- (instancetype)initWithLibRdfStatement:(void *)statement;

@end

NS_ASSUME_NONNULL_END
