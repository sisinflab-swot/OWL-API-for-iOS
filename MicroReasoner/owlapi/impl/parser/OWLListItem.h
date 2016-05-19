//
//  OWLListItem.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 19/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Represents an item in RDF lists.
@interface OWLListItem : NSObject

@property (nonatomic, copy) NSString *first;
@property (nonatomic, copy) NSString *rest;

@end
