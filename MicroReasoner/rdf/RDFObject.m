//
//  RDFObject.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 23/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "RDFObject.h"

@implementation RDFObject

- (id)initWithWrappedObject:(void *)object
{
    return [self initWithWrappedObject:object owner:YES];
}

- (id)initWithWrappedObject:(void *)object owner:(BOOL)owner
{
    NSParameterAssert(object);
    
    if ((self = [super init])) {
        _wrappedObject = object;
        _owner = owner;
    }
    return self;
}

@end
