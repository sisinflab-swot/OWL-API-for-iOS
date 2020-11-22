//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObject.h"

extern bool signatureIteratorImpl(void *ctx, void *entity);

/// Abstract class that provides sensible defaults for methods of the OWLObject protocol.
@interface OWLObjectImpl : NSObject <NSCopying>
{
    @protected
    void *_cowlObject;
}

@property (nonatomic, readonly) void* cowlObject;

#pragma mark OWLObject

- (void)enumerateClassesInSignatureWithHandler:(void (^)(id<OWLClass> owlClass))handler;
- (void)enumerateNamedIndividualsInSignatureWithHandler:(void (^)(id<OWLNamedIndividual> ind))handler;
- (void)enumerateObjectPropertiesInSignatureWithHandler:(void (^)(id<OWLObjectProperty> prop))handler;

@end
