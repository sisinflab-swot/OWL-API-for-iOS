//
//  OWLObjectImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 05/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLEntity.h"
#import "SMRPreprocessor.h"

@implementation OWLObjectImpl

#pragma mark OWLObject

- (NSSet<id<OWLClass>> *)classesInSignature
{
    NSMutableSet<id<OWLClass>> *classes = [[NSMutableSet alloc] init];
    for (id<OWLEntity> entity in self.signature) {
        if (entity.isOWLClass) {
            [classes addObject:(id<OWLClass>)entity];
        }
    }
    return classes;
}

- (NSSet<id<OWLEntity>> *)signature ABSTRACT_METHOD;

@end
