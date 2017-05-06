//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAbstractBuilder.h"
#import "OWLPropertyBuilderType.h"

@protocol OWLPropertyExpression;

NS_ASSUME_NONNULL_BEGIN

/// Property builder class.
@interface OWLPropertyBuilder : NSObject <OWLAbstractBuilder>

#pragma mark OWLAbstractBuilder

- (nullable id<OWLPropertyExpression>)build;

#pragma mark General

/// The type of the built property.
DECLARE_BUILDER_VALUE_PROPERTY(OWLPBType, type, Type)


#pragma mark Named properties

/// The string representation of the property IRI.
DECLARE_BUILDER_STRING_PROPERTY(namedPropertyID, NamedPropertyID)

@end

NS_ASSUME_NONNULL_END
