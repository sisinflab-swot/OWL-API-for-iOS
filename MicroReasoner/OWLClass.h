//
//  OWLClass.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWLClass : NSObject

#pragma mark Properties

@property (nonatomic, copy, readonly) NSURL *iri;

#pragma mark Methods

- (instancetype)initWithIRI:(NSURL *)iri;

@end

NS_ASSUME_NONNULL_END
