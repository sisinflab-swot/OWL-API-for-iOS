//
//  OWLClassImpl.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 04/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClass.h"

@interface OWLClassImpl : NSObject <OWLClass>

- (instancetype)initWithIRI:(NSURL *)IRI;

@end
