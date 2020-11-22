//
//  Created by Ivano Bilenchi on 12/05/2020.
//  Copyright © 2020 SisInf Lab. All rights reserved.
//

#import "OWLParser.h"
#import "OWLCowlUtils.h"
#import "OWLOntologyImpl.h"

#import <cowl_parser.h>
#import <uvec.h>

@implementation OWLParser

@synthesize manager = _manager;

- (instancetype)initWithManager:(id<OWLOntologyManager>)manager {
    NSParameterAssert(manager);
    if ((self = [super init])) {
        _manager = manager;
    }
    return self;
}

- (id<OWLOntology>)parseOntologyFromDocumentAtURL:(NSURL *)URL
                                            error:(NSError * _Nullable __autoreleasing *)error {
    id<OWLOntology> ontology = nil;
    NSError *localError = nil;

    CowlParser *parser = cowl_parser_get();
    UVec(CowlError) errors = uvec_init(CowlError);
    const char *path = [[URL path] UTF8String];

    CowlOntology *onto = cowl_parser_parse_ontology(parser, path, &errors);

    if (onto) {
        ontology = [[OWLOntologyImpl alloc] initWithCowlOntology:onto manager:_manager retain:NO];
    } else if (uvec_count(&errors)) {
        localError = errorFromCowl(uvec_last(&errors));
    }

    uvec_deinit(errors);
    cowl_parser_release(parser);

    if (error) *error = localError;
    return ontology;
}

@end
