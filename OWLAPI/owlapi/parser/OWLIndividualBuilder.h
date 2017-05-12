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
DECLARE_BUILDER_VALUE_PROPERTY(OWLIBType, type, Type)

/// The IRI of the individual to build.
DECLARE_BUILDER_CSTRING_PROPERTY(IRI, IRI)

@end

NS_ASSUME_NONNULL_END
