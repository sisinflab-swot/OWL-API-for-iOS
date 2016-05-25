//
//  OWLNodeID.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 25/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Represents the ID of an anonymous OWL node.
typedef uint64_t OWLNodeID;

/// Generates a new unique node ID.
extern OWLNodeID OWLNodeID_new(void);

/// Returns the string representation of a given node ID.
extern NSString * OWLNodeID_toString(OWLNodeID ID);

NS_ASSUME_NONNULL_END
