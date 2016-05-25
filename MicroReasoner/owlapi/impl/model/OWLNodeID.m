//
//  OWLNodeID.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 25/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLNodeID.h"

OWLNodeID OWLNodeID_new(void)
{
    static OWLNodeID idCounter = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uint32_t const range = 1782;
        idCounter = arc4random_uniform(range) + range;
    });
    
    if (idCounter == 0) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Exceeded the maximum number of anonymous node identifiers."
                                     userInfo:nil];
    }
    return idCounter++;
}

NSString * OWLNodeID_toString(OWLNodeID ID)
{
    return [NSString stringWithFormat:@"%llu", ID];
}
