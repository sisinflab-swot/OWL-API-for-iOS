//
//  OWLObjectImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"

/// Abstract class that informally implements part of the OWLObject protocol.
@interface OWLObjectImpl : NSObject

#pragma mark OWLObject

- (NSSet<id<OWLClass>> *)classesInSignature;

@end
