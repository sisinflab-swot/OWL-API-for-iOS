//
//  OWLIndividualBuilder.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAbstractBuilder.h"

@protocol OWLIndividual;

NS_ASSUME_NONNULL_BEGIN

/// Individual builder class.
@interface OWLIndividualBuilder : NSObject <OWLAbstractBuilder>

#pragma mark OWLAbstractBuilder

- (nullable id<OWLIndividual>)build;

#pragma mark Named individual

/// The string representation of the individual IRI.
@property (nonatomic, strong, readonly, nullable) NSString *namedIndividualID;

/**
 * Sets the string representation of the individual IRI.
 *
 * @return NO if the ID was already set, YES otherwise.
 */
- (BOOL)setNamedIndividualID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
