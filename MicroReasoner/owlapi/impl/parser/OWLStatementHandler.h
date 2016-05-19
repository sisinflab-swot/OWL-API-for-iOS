//
//  OWLStatementHandler.h
//  MicroReasoner
//
//  Created by Ivano Bilenchi on 17/05/16.
//  Copyright © 2016 SisInf Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RedlandStatement;
@class OWLOntologyBuilder;

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^OWLStatementHandler)(RedlandStatement *_Nonnull, OWLOntologyBuilder *_Nonnull, NSError *_Nullable __autoreleasing *);

extern OWLStatementHandler pAllValuesFromHandler;
extern OWLStatementHandler pMinCardinalityHandler;
extern OWLStatementHandler pOnPropertyHandler;
extern OWLStatementHandler pRDFTypeHandler;
extern OWLStatementHandler pSomeValuesFromHandler;
extern OWLStatementHandler pSubClassOfHandler;

extern OWLStatementHandler oClassHandler;
extern OWLStatementHandler oNamedIndividualHandler;
extern OWLStatementHandler oObjectPropertyHandler;
extern OWLStatementHandler oRestrictionHandler;

NS_ASSUME_NONNULL_END
