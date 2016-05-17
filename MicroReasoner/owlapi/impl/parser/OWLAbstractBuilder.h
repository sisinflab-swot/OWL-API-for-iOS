//
//  OWLAbstractBuilder.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OWLAbstractBuilder <NSObject>

- (nullable id)build;

@end

NS_ASSUME_NONNULL_END
