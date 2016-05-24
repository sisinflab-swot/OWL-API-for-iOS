//
//  RDFStatement.m
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 23/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "RDFStatement.h"
#import "RDFNode.h"
#import "redland.h"

@implementation RDFStatement

@synthesize subject = _subject;
@synthesize predicate = _predicate;
@synthesize object = _object;

- (instancetype)initWithLibRdfStatement:(void *)statement
{
    if ((self = [super init])) {
        librdf_node *node = librdf_statement_get_subject(statement);
        _subject = [[RDFNode alloc] initWithLibRdfNode:node];
        
        node = librdf_statement_get_predicate(statement);
        _predicate = [[RDFNode alloc] initWithLibRdfNode:node];
        
        node = librdf_statement_get_object(statement);
        _object = [[RDFNode alloc] initWithLibRdfNode:node];
    }
    return self;
}

@end
