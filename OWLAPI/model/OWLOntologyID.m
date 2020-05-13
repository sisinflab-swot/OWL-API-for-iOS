//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLOntologyID+Private.h"
#import "OWLCowlUtils.h"
#import "OWLIRI+Private.h"

@implementation OWLOntologyID

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_ontology_id_equals(_cowlID, ((OWLOntologyID *)object)->_cowlID);
}

- (NSUInteger)hash { return cowl_ontology_id_hash(_cowlID); }

- (NSString *)description {
    return stringFromCowl(cowl_ontology_id_to_string(_cowlID), YES);
}

#pragma mark Public methods

@synthesize cowlID = _cowlID;

- (OWLIRI *)ontologyIRI {
    return [[OWLIRI alloc] initWithCowlIRI:_cowlID.ontology_iri retain:YES];
}

- (OWLIRI *)versionIRI {
    return [[OWLIRI alloc] initWithCowlIRI:_cowlID.version_iri retain:YES];
}

- (instancetype)initWithCowlID:(CowlOntologyID)cowlID {
    if ((self = [super init])) {
        _cowlID = cowlID;
    }
    return self;
}

- (id)copyWithZone:(__unused NSZone *)zone { return self; }

@end
