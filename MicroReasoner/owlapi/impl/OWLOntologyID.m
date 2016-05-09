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
@synthesize versionIRI = _versionIRI;

#pragma mark Public methods

- (instancetype)initWithOntologyIRI:(NSURL *)ontologyIRI versionIRI:(NSURL *)versionIRI
{
    if ((self = [super init])) {
        _ontologyIRI = [ontologyIRI copy];
        _versionIRI = [versionIRI copy];
    }
    return self;
}

- (instancetype)initWithOntologyIRI:(NSURL *)ontologyIRI
{
    return [self initWithOntologyIRI:ontologyIRI versionIRI:nil];
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([object isKindOfClass:[self class]]) {
        NSURL *objIRI = [object ontologyIRI];
        NSURL *selfIRI = self.ontologyIRI;
        BOOL sameOntoIRI = (objIRI == selfIRI || [objIRI isEqual:selfIRI]);
        
        objIRI = [object versionIRI];
        selfIRI = self.versionIRI;
        BOOL sameVerIRI = (objIRI == selfIRI || [objIRI isEqual:selfIRI]);
        
        equal = (sameOntoIRI && sameVerIRI);
    }
    
    return equal;
}

- (NSUInteger)hash { return [self.ontologyIRI hash] ^ [self.versionIRI hash]; }

#pragma mark NSCopying

// This object is immutable.
- (id)copyWithZone:(__unused NSZone *)zone { return self; }

@end
