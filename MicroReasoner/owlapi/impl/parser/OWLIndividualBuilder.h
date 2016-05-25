//
//  OWLIndividualBuilder.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAbstractBuilder.h"
#import "OWLIndividualBuilderType.h"

@protocol OWLIndividual;

NS_ASSUME_NONNULL_BEGIN

/// Individual builder class.
@interface OWLIndividualBuilder : NSObject <OWLAbstractBuilder>

#pragma mark OWLAbstractBuilder

- (nullable id<OWLIndividual>)build;

#pragma mark General

/// The type of the individual to build.
@property (nonatomic, readonly) OWLIBType type;

/// Sets the type of the individual to build.
- (BOOL)setType:(OWLIBType)type error:(NSError *_Nullable __autoreleasing *)error;

/// The ID of the individual to build.
@property (nonatomic, strong, readonly, nullable) NSString *ID;

/// Sets the ID of the individual to build.
- (BOOL)setID:(NSString *)ID error:(NSError *_Nullable __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
