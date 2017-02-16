//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"

@class OWLIRI;

NS_ASSUME_NONNULL_BEGIN

/**
 * Represents a named object for example, class, property, ontology etc.
 * - i.e. anything that has an IRI as its name.
 **/
@protocol OWLNamedObject <OWLObject>

/// The IRI of this object.
@property (nonatomic, copy, readonly) OWLIRI *IRI;

@end

NS_ASSUME_NONNULL_END
