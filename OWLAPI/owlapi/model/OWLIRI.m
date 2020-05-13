//
//  Created by Ivano Bilenchi on 16/02/17.
//  Copyright © 2017-2020 SisInf Lab. All rights reserved.
//

#import "OWLIRI+Private.h"
#import "OWLCowlUtils.h"

#import "cowl_iri.h"

@implementation OWLIRI

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    return cowl_iri_equals(_cowlIRI, ((OWLIRI *)object)->_cowlIRI);
}

- (NSUInteger)hash { return (NSUInteger)cowl_iri_hash(_cowlIRI); }

- (NSString *)description { return self.string; }

#pragma mark OWLIRI

@synthesize cowlIRI = _cowlIRI;

- (NSString *)string {
    return stringFromCowl(cowl_iri_to_string_no_brackets(_cowlIRI), YES);
}

- (NSString *)namespace {
    return stringFromCowl(cowl_iri_get_ns(_cowlIRI), NO);
}

- (NSString *)remainder {
    return stringFromCowl(cowl_iri_get_rem(_cowlIRI), NO);
}

- (NSString *)scheme {
    NSString *string = self.string;
    NSUInteger index = [string rangeOfString:@":"].location;
    return index == NSNotFound ? nil : [string substringToIndex:index];
}

- (NSComparisonResult)compare:(OWLIRI *)iri {
    return [self.string compare:iri.string];
}

#pragma mark Lifecycle

- (instancetype)initWithCowlIRI:(CowlIRI *)cowlIRI retain:(BOOL)retain {
    NSParameterAssert(cowlIRI);
    if ((self = [super init])) {
        _cowlIRI = retain ? cowl_iri_retain(cowlIRI) : cowlIRI;
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string {
    char const *cstr = [string UTF8String];
    return cstr ? [self initWithCString:cstr] : nil;
}

- (instancetype)initWithCString:(char const *)string {
    NSParameterAssert(string);
    return [self initWithCowlIRI:cowl_iri_from_cstring(string, strlen(string)) retain:NO];
}

- (void)dealloc { cowl_iri_release(_cowlIRI); }

- (id)copyWithZone:(__unused NSZone *)zone { return self; }

@end
