//
//  Created by Ivano Bilenchi on 16/02/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import "OWLIRI.h"
#import "NSMapTable+SMRObjectCache.h"

@implementation OWLIRI

#pragma mark NSObject

- (BOOL)isEqual:(id)object { return object == self; }

- (NSUInteger)hash { return (NSUInteger)self; }

- (NSString *)description
{
    return _string;
}

#pragma mark NSCopying

// This object is immutable.
- (id)copyWithZone:(__unused NSZone *)zone { return self; }

#pragma mark OWLIRI

@synthesize string = _string;

#pragma mark Lifecycle

static NSMapTable *instanceCache = nil;

+ (void)initialize
{
    if (self == [OWLIRI class]) {
        instanceCache = [NSMapTable smr_objCache];
    }
}

- (instancetype)initWithString:(NSString *)string
{
    NSParameterAssert(string);
    
    id cachedInstance = [instanceCache objectForKey:string];
    
    if (cachedInstance) {
        self = cachedInstance;
    } else {
        if ((self = [super init])) {
            _string = [string copy];
            [instanceCache setObject:self forKey:_string];
        }
    }
    return self;
}

@end
