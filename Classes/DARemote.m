//
//  DARemote.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "DARemote.h"
#import "TouchXML.h"
#import "Entry.h"

@implementation DARemote

+ (NSArray *)searchEntries:(NSString *)word error:(NSError **)error {
    // TODO: Connection error checking
    // TODO: Cache results
    
    // TODO: Check for potential memory leaks here
    NSMutableArray *entries = [[[NSMutableArray alloc] init] autorelease];
    
    if ([word length]) {
        // Obtain definition from DicionarioAberto API
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dicionario-aberto.net/search-xml/%@", [word stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSString *result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
        CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:0 error:error];
        
        for (CXMLElement *ee in [doc nodesForXPath:@"//entry" error:nil]) {
            Entry *entry = [[Entry alloc] initFromXMLString:[ee XMLString] error:nil];
            if (entry) [entries addObject:entry];
            [entry release];
        }
    
        [doc release];
    }
    
    return entries;
}

+ (NSArray *)searchWithPrefix:(NSString *)prefix error:(NSError **)error {
    // TODO: Connection error checking
    // TODO: Cache results
    
    // TODO: Check for potential memory leaks here
    NSMutableArray *entries = [[[NSMutableArray alloc] init] autorelease];
    
    if ([prefix length]) {
        // Obtain definition from DicionarioAberto API
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dicionario-aberto.net/search-xml?prefix=%@", [prefix stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSString *result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
        CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:0 error:error];
    
        for (CXMLElement *ee in [doc nodesForXPath:@"//list/entry" error:nil]) {
            [entries addObject:[ee stringValue]];
        }
    
        [doc release];
    }
    
    return entries;
}

+ (NSArray *)searchWithSuffix:(NSString *)suffix error:(NSError **)error {
    // TODO: Connection error checking
    // TODO: Cache results
    
    // TODO: Check for potential memory leaks here
    NSMutableArray *entries = [[[NSMutableArray alloc] init] autorelease];
    
    if ([suffix length]) {
        // Obtain definition from DicionarioAberto API
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dicionario-aberto.net/search-xml?suffix=%@", [suffix stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSString *result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
        CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:0 error:error];
    
        for (CXMLElement *ee in [doc nodesForXPath:@"//list/entry" error:nil]) {
            [entries addObject:[ee stringValue]];
        }
    
        [doc release];
    }
    
    return entries;
}

+ (NSArray *)searchSimilar:(NSString *)word error:(NSError **)error {
    return nil;
}

@end
