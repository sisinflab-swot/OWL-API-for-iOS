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

- (void)dealloc
{
    if (_owner) {
        librdf_free_statement(_wrappedObject);
    }
}

- (RDFNode *)subject
{
    librdf_node *node = librdf_statement_get_subject(_wrappedObject);
    if (_owner && node) {
        node = librdf_new_node_from_node(node);
    }
    return [[RDFNode alloc] initWithWrappedObject:node owner:_owner];
}

- (RDFNode *)predicate
{
    librdf_node *node = librdf_statement_get_predicate(_wrappedObject);
    if (_owner && node) {
        node = librdf_new_node_from_node(node);
    }
    return [[RDFNode alloc] initWithWrappedObject:node owner:_owner];
}

- (RDFNode *)object
{
    librdf_node *node = librdf_statement_get_object(_wrappedObject);
    if (_owner && node) {
        node = librdf_new_node_from_node(node);
    }
    return [[RDFNode alloc] initWithWrappedObject:node owner:_owner];
}

@end
