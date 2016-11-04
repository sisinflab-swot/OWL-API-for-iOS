//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLAxiom.h"

@protocol OWLEntity;

NS_ASSUME_NONNULL_BEGIN

@protocol OWLDeclarationAxiom <OWLAxiom>

/// The entity that this axiom declares.
@property (nonatomic, strong, readonly) id<OWLEntity> entity;

@end

NS_ASSUME_NONNULL_END
