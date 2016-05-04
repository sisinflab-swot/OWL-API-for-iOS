//
//  RedlandNamespace+OWLAdditions.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "RedlandNamespace+OWLAdditions.h"

RedlandNamespace *OWLSyntaxNS = nil;

@implementation RedlandNamespace (OWLAdditions)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OWLSyntaxNS = [[RedlandNamespace alloc] initWithPrefix:@"http://www.w3.org/2002/07/owl#" shortName:@"owl"];
    });
}

@end
