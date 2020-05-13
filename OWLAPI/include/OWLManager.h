//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OWLOntologyManager;

NS_ASSUME_NONNULL_BEGIN

/// Provides a point of convenience for creating an OWLOntologyManager.
@interface OWLManager : NSObject

/**
 * Creates an OWL ontology manager with default configuration.
 *
 * @return The new ontology manager.
 */
+ (id<OWLOntologyManager>)createOWLOntologyManager;

@end

NS_ASSUME_NONNULL_END
