//
//  Created by Ivano Bilenchi on 09/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import "OWLClassAxiom.h"
#import "OWLNAryAxiom.h"

@protocol OWLClassExpression;

NS_ASSUME_NONNULL_BEGIN

@protocol OWLNAryClassAxiom <OWLClassAxiom, OWLNAryAxiom>

/// The top level class expressions that appear in this axiom.
@property (nonatomic, copy, readonly) NSSet<id<OWLClassExpression>> *classExpressions;

@end

NS_ASSUME_NONNULL_END
