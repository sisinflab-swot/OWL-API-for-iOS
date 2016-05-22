//
//  OWLIndividualRelationshipAxiomImpl.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 22/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLIndividualRelationshipAxiomImpl.h"
#import "OWLIndividual.h"
#import "OWLPropertyAssertionObject.h"
#import "OWLPropertyExpression.h"

@implementation OWLIndividualRelationshipAxiomImpl

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    if (object == self) {
        return YES;
    }
    
    BOOL equal = NO;
    
    if ([super isEqual:object]) {
        id objVar = [object subject];
        BOOL sameSubject = (objVar == _subject || [objVar isEqual:_subject]);
        
        objVar = [object property];
        BOOL sameProperty = (objVar == _property || [objVar isEqual:_property]);
        
        objVar = [(id<OWLPropertyAssertionAxiom>)object object];
        BOOL sameObject = (objVar == _object || [objVar isEqual:_object]);
        
        equal = sameSubject && sameProperty && sameObject;
    }
    
    return equal;
}

- (NSUInteger)computeHash { return [_subject hash] ^ [_property hash] ^ [_object hash]; }

#pragma mark OWLPropertyAssertionAxiom

@synthesize subject = _subject;
@synthesize property = _property;
@synthesize object = _object;

#pragma mark Other public methods

- (instancetype)initWithSubject:(id<OWLIndividual>)subject
                       property:(id<OWLPropertyExpression>)property
                         object:(id<OWLPropertyAssertionObject>)object
{
    NSParameterAssert(subject && property && object);
    
    if ((self = [super init])) {
        _subject = [(id)subject copy];
        _property = [(id)property copy];
        _object = [(id)object copy];
    }
    return self;
}

@end
