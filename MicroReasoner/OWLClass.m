//
//  OWLClass.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 01/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClass.h"

@implementation OWLClass

#pragma mark Properties

@synthesize iri = _iri;

#pragma mark Public methods

- (instancetype)initWithIRI:(NSURL *)iri
{
    if ((self = [super init])) {
        _iri = [iri copy];
    }
    return self;
}

- (NSString *)description
{
    return [self.iri absoluteString];
}

@end
