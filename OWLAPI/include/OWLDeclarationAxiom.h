//
//  Created by Ivano Bilenchi on 12/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLAxiom.h"

@protocol OWLEntity;

NS_ASSUME_NONNULL_BEGIN

/// Represents a Declaration in the OWL 2 specification.
@protocol OWLDeclarationAxiom <OWLAxiom>

/// The entity that this axiom declares.
@property (nonatomic, strong, readonly) id<OWLEntity> entity;

@end

NS_ASSUME_NONNULL_END
