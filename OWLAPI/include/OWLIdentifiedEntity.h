//
//  Created by Ivano Bilenchi on 14/05/2020.
//  Copyright © 2020 SisInf Lab. All rights reserved.
//

#import "OWLEntity.h"
#import "OWLEntityID.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Allows the conversion of OWLEntity to numerical identifiers and back.
 *
 * @warning This protocol is very unsafe, so it should be used sparingly.
 * @note All OWLEntity instances also implement this protocol,
 *       so it can be used by simply casting to OWLIdentifiedEntity.
 */
@protocol OWLIdentifiedEntity <OWLEntity>

/**
 * The identifier of this entity.
 *
 * @warning The identifier is only valid until the entity is dealloated. Attempts to use it
 *          after the entity has been deallocated is undefined behavior.
 */
@property (nonatomic, readonly) OWLEntityID identifier;

@end

NS_ASSUME_NONNULL_END
