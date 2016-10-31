//
//  Created by Ivano Bilenchi on 23/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "RDFStatement.h"
#import "RDFNode.h"

@implementation RDFStatement

@synthesize subject = _subject;
@synthesize predicate = _predicate;
@synthesize object = _object;

- (instancetype)initWithRaptorStatement:(raptor_statement *)statement
{
    if ((self = [super init])) {
        
        raptor_term *term = statement->subject;
        if (!term) {
            return nil;
        }
        _subject = [[RDFNode alloc] initWithRaptorTerm:term];
        
        term = statement->predicate;
        if (!term) {
            return nil;
        }
        _predicate = [[RDFNode alloc] initWithRaptorTerm:term];
        
        term = statement->object;
        if (!term) {
            return nil;
        }
        _object = [[RDFNode alloc] initWithRaptorTerm:term];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"RDFStatement('%@' '%@' '%@')", _subject, _predicate, _object];
}

@end
