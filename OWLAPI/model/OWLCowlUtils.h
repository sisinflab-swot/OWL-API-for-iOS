//
//  Created by Ivano Bilenchi on 10/05/2020.
//  Copyright © 2020 SisInf Lab. All rights reserved.
//

#import "OWLAxiomType.h"
#import "cowl_axiom_type.h"
#import "cowl_error.h"

cowl_struct_decl(CowlAnonInd);
cowl_struct_decl(CowlAxiom);
cowl_struct_decl(CowlClass);
cowl_struct_decl(CowlClsExp);
cowl_struct_decl(CowlEntity);
cowl_struct_decl(CowlIndividual);
cowl_struct_decl(CowlNamedInd);
cowl_struct_decl(CowlObjProp);
cowl_struct_decl(CowlObjPropExp);
cowl_struct_decl(CowlString);
cowl_hash_decl(CowlClsExpSet);

@protocol OWLAnonymousIndividual;
@protocol OWLAxiom;
@protocol OWLClass;
@protocol OWLClassExpression;
@protocol OWLEntity;
@protocol OWLIndividual;
@protocol OWLNamedIndividual;
@protocol OWLObjectProperty;
@protocol OWLObjectPropertyExpression;

extern CowlAxiomType cowlAxiomTypeFrom(OWLAxiomType type);
extern CowlClsExpSet* cowlClsExpSetFrom(NSSet<id<OWLClassExpression>> *set);
extern CowlEntity* cowlEntityFrom(id<OWLEntity> entity);
extern void* cowlWrappedObject(id object);

extern OWLAxiomType axiomTypeFromCowl(CowlAxiomType type);
extern id<OWLAxiom> axiomFromCowl(CowlAxiom *axiom, BOOL retain);
extern id<OWLClass> classFromCowl(CowlClass *cls, BOOL retain);
extern id<OWLClassExpression> classExpressionFromCowl(CowlClsExp *exp, BOOL retain);
extern NSSet<id<OWLClassExpression>>* classExpressionSetFromCowl(CowlClsExpSet *set, BOOL retain);
extern id<OWLEntity> entityFromCowl(CowlEntity *entity, BOOL retain);
extern NSError* errorFromCowl(CowlError error);
extern id<OWLIndividual> individualFromCowl(CowlIndividual *ind, BOOL retain);
extern id<OWLNamedIndividual> namedIndFromCowl(CowlNamedInd *ind, BOOL retain);
extern id<OWLObjectProperty> objPropFromCowl(CowlObjProp *prop, BOOL retain);
extern id<OWLObjectPropertyExpression> objPropExpFromCowl(CowlObjPropExp *exp, BOOL retain);
extern NSString* stringFromCowl(CowlString *string, BOOL release);
