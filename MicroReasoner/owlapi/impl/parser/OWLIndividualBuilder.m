//
//  OWLIndividualBuilder.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLIndividualBuilder.h"
#import "OWLError.h"
#import "OWLNamedIndividualImpl.h"

@implementation OWLIndividualBuilder

#pragma mark OWLAbstractBuilder

- (id<OWLIndividual>)build
{
    id<OWLIndividual> builtIndividual = nil;
    
    NSString *ID = self.namedIndividualID;
    if (ID) {
        NSURL *IRI = [[NSURL alloc] initWithString:ID];
        if (IRI) {
            builtIndividual = [[OWLNamedIndividualImpl alloc] initWithIRI:IRI];
        }
    }
    
    return builtIndividual;
}

#pragma mark Named individual

// namedIndividualID
@synthesize namedIndividualID = _namedIndividualID;

- (BOOL)setNamedIndividualID:(NSString *)ID error:(NSError *__autoreleasing *)error
{
    if (_namedIndividualID == ID || [_namedIndividualID isEqualToString:ID]) {
        return YES;
    }
    
    BOOL success = NO;
    
    if (!_namedIndividualID) {
        _namedIndividualID = [ID copy];
        success = YES;
    } else if (error) {
        *error = [NSError OWLErrorWithCode:OWLErrorCodeSyntax
                      localizedDescription:@"Multiple IRIs for individual."
                                  userInfo:@{@"individualIDs": @[_namedIndividualID, ID]}];
    }
    
    return success;
}

@end