//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLObjectImpl.h"
#import "OWLOntology.h"

#import <cowl_compat.h>

cowl_struct_decl(CowlOntology);

NS_ASSUME_NONNULL_BEGIN

@interface OWLOntologyImpl : OWLObjectImpl <OWLOntology>

@property (nonatomic, strong, readwrite) id<OWLOntologyManager> manager;

- (instancetype)initWithCowlOntology:(CowlOntology *)ontology
                             manager:(id<OWLOntologyManager>)manager
                              retain:(BOOL)retain;

@end

NS_ASSUME_NONNULL_END
