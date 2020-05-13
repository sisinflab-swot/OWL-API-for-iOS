//
//  Created by Ivano Bilenchi on 12/05/2020.
//  Copyright © 2020 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OWLOntology;
@protocol OWLOntologyManager;

NS_ASSUME_NONNULL_BEGIN

@interface OWLParser : NSObject

@property (nonatomic, strong, readonly) id<OWLOntologyManager>manager;

- (instancetype)initWithManager:(id<OWLOntologyManager>)manager;
- (nullable id<OWLOntology>)parseOntologyFromDocumentAtURL:(NSURL *)URL
                                                     error:(NSError *_Nullable __autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
