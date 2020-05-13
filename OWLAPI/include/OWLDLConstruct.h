//
//  Created by Ivano Bilenchi on 23/05/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Models DL construct families.
typedef NS_OPTIONS(NSInteger, OWLDLConstruct) {
    
    /// AL - Attributive language.
    OWLDLConstructAL            = 1 << 0,
    
    /// EL - Existential language.
    OWLDLConstructEL            = 1 << 1,
    
    /// U - Concept union.
    OWLDLConstructU             = 1 << 2,
    
    /// C - Complex concept negation.
    OWLDLConstructC             = 1 << 3,
    
    /// E - Qualified existential restriction.
    OWLDLConstructE             = 1 << 4,
    
    /// N - Cardinality restrictions.
    OWLDLConstructN             = 1 << 5,
    
    /// Q - Qualified cardinality restrictions.
    OWLDLConstructQ             = 1 << 6,
    
    /// H - Role hierarchies.
    OWLDLConstructH             = 1 << 7,
    
    /// I - Inverse properties.
    OWLDLConstructI             = 1 << 8,
    
    /// O - Nominals.
    OWLDLConstructO             = 1 << 9,
    
    /// F - Functional properties.
    OWLDLConstructF             = 1 << 10,
    
    /// + - Transitive properties.
    OWLDLConstructTRAN          = 1 << 11,
    
    /// D - Datatypes.
    OWLDLConstructD             = 1 << 12,
    
    /// R - Complex role inclusions, role disjointness, (ir)reflexivity.
    OWLDLConstructR             = 1 << 13,
    
    /// S - Shorthand for ALC+.
    OWLDLConstructS             = (OWLDLConstructAL | OWLDLConstructC | OWLDLConstructTRAN),
    
    /// EL++ - Shorthand for ELRO.
    OWLDLConstructELPLUSPLUS    = (OWLDLConstructEL | OWLDLConstructR | OWLDLConstructO)
};
