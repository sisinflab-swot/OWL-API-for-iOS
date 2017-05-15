//
//  Created by Ivano Bilenchi on 16/02/17.
//  Copyright © 2017 SisInf Lab. All rights reserved.
//

#import "OWLIRI.h"
#import "OWLMap.h"
#import "OWLObjCUtils.h"

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

SYNTHESIZE_LAZY(NSString, string, {
    NSString *string = [[NSString alloc] initWithBytesNoCopy:_cString
                                                      length:strlen((char *)_cString)
                                                    encoding:NSUTF8StringEncoding
                                                freeWhenDone:NO];
    _string = string ?: @"";
})

#pragma mark Lifecycle

static OWLMap *instanceCache = NULL;

+ (void)initialize
{
    if (self == [OWLIRI class]) {
        instanceCache = owl_map_init(COPY_TO_WEAK);
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
            _cString = owl_map_set_obj(instanceCache, string, self);
        }
    }
    return self;
}

- (void)dealloc
{
    if (_cString) {
        owl_map_set(instanceCache, _cString, nil);
    }
}

@end
