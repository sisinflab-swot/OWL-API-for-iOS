//
//  Created by Ivano Bilenchi on 11/05/2020.
//  Copyright © 2020 SisInf Lab. All rights reserved.
//

#import "OWLOntologyID.h"
#import "cowl_ontology_id.h"

@interface OWLOntologyID ()

@property (nonatomic, readonly) CowlOntologyID cowlID;

- (instancetype)initWithCowlID:(CowlOntologyID)cowlID;

@end
