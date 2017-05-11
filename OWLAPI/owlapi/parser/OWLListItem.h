//
//  Created by Ivano Bilenchi on 19/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Represents an item in RDF lists.
@interface OWLListItem : NSObject

@property (nonatomic) unsigned char *first;
@property (nonatomic) unsigned char *rest;

@end
