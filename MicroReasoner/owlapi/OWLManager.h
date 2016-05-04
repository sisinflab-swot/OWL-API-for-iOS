//
//  OWLManager.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OWLOntologyManager;

NS_ASSUME_NONNULL_BEGIN

@interface OWLManager : NSObject

+ (id<OWLOntologyManager>)createOWLOntologyManager;

@end

NS_ASSUME_NONNULL_END
