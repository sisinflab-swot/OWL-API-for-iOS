//
//  Created by Ivano Bilenchi on 03/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLManager.h"
#import "OWLDataFactoryImpl.h"
#import "OWLOntologyManagerImpl.h"

@implementation OWLManager

+ (id<OWLOntologyManager>)createOWLOntologyManager
{
    id<OWLDataFactory> dataFactory = [[OWLDataFactoryImpl alloc] init];
    return [[OWLOntologyManagerImpl alloc] initWithDataFactory:dataFactory];
}

@end
