//
//  Created by Ivano Bilenchi on 16/02/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import "OWLIRI.h"
#import "OWLMap.h"

@implementation OWLIRI
{
    unsigned char *_cString;
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object { return object == self; }

- (NSUInteger)hash { return (NSUInteger)self; }

- (NSString *)description { return self.string; }

#pragma mark NSCopying

// This object is immutable.
- (id)copyWithZone:(__unused NSZone *)zone { return self; }

#pragma mark OWLIRI

- (NSString *)string
{
    NSString *string = [NSString stringWithCString:(char *)_cString encoding:NSUTF8StringEncoding];
    return string ?: @"";
}

#pragma mark Lifecycle

static OWLMap *instanceCache = NULL;

+ (void)initialize
{
    if (self == [OWLIRI class]) {
        instanceCache = owl_map_init(NONE);
    }
}

- (instancetype)initWithString:(NSString *)string
{
    return [self initWithCString:(unsigned char *)[string UTF8String]];
}

- (instancetype)initWithCString:(unsigned char *)string
{
    NSParameterAssert(string);
    
    id cachedInstance = owl_map_get_obj(instanceCache, string);
    
    if (cachedInstance) {
        self = cachedInstance;
    } else {
        if ((self = [super init])) {
            _cString = owl_map_set(instanceCache, string, (__bridge void *)(self));
        }
    }
    return self;
}

- (void)dealloc
{
    if (_cString) {
        owl_map_set(instanceCache, _cString, NULL);
    }
}

@end
