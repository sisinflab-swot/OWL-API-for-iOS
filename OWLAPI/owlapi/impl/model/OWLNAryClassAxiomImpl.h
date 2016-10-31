//
//  Created by Ivano Bilenchi on 09/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLLogicalAxiomImpl.h"
#import "OWLNAryClassAxiom.h"

NS_ASSUME_NONNULL_BEGIN

/// Abstract class that informally implements part of the OWLNAryClassAxiom protocol.
@interface OWLNAryClassAxiomImpl : OWLLogicalAxiomImpl

#pragma mark OWLObject

- (NSMutableSet<id<OWLEntity>> *)signature;

#pragma mark OWLNAryClassAxiom

@property (nonatomic, copy, readonly) NSSet<id<OWLClassExpression>> *classExpressions;

#pragma mark Other public methods

- (instancetype)initWithClassExpressions:(NSSet<id<OWLClassExpression>> *)classExpressions;

@end

NS_ASSUME_NONNULL_END
