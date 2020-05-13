//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016-2020 SisInf Lab. All rights reserved.
//

#import "OWLManager.h"
#import "OWLDataFactoryImpl.h"
#import "OWLOntologyManagerImpl.h"
#import "cowl_init.h"

@implementation OWLManager

+ (void)load {
    cowl_api_init();
}

+ (id<OWLOntologyManager>)createOWLOntologyManager {
    id<OWLDataFactory> dataFactory = [[OWLDataFactoryImpl alloc] init];
    return [[OWLOntologyManagerImpl alloc] initWithDataFactory:dataFactory];
}

@end
