//
//  OWLOntologyID.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLOntologyID.h"

@implementation OWLOntologyID

#pragma mark Properties

@synthesize ontologyIRI = _ontologyIRI;

#pragma mark Public methods

- (instancetype)initWithOntologyIRI:(NSURL *)ontologyIRI
{    
    if ((self = [super init])) {
        _ontologyIRI = [ontologyIRI copy];
    }
    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(__unused NSZone *)zone
{
    return [[[self class] alloc] initWithOntologyIRI:self.ontologyIRI];
}

@end
