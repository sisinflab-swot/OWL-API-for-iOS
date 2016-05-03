//
//  OWLOntology.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OWLClass;
@class RedlandStatement;

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntology : NSObject

#pragma mark Properties

@property (nonatomic, copy, readonly) NSArray<RedlandStatement *> *allStatements;
@property (nonatomic, copy, readonly) NSDictionary<NSURL *, OWLClass *> *classesInSignature;

#pragma mark Methods

- (instancetype)initWithContentsOfURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
