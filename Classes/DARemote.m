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

#define DA_RESULTS_CACHE 50

int const DARemoteSearchPrefix  = 1;
int const DARemoteSearchSuffix  = 2;
int const DARemoteSearchLike    = 3;

@implementation DARemote

+ (NSArray *)getEntries:(NSString *)word error:(NSError **)error {
    // TODO: Connection error checking
    
    NSLog(@"Remote API call: search-xml '%@'", word);
    
    NSMutableArray *entries = [[[NSMutableArray alloc] init] autorelease];
    
    if ([word length]) {
        
        // TODO: Obtain definition from cache, if present
        
        // Obtain definition from DicionarioAberto API
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dicionario-aberto.net/search-xml/%@", [word stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        NSString *result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];

        if (result) {
            // TODO: Cache word -> result (up to DA_RESULTS_CACHE results)
            
            CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:0 error:error];
            
            for (CXMLElement *ee in [doc nodesForXPath:@"//entry" error:nil]) {
                Entry *entry = [[Entry alloc] initFromXMLString:[ee XMLString] error:nil];
                if (entry) [entries addObject:entry];
                [entry release];
            }
            
            [doc release];
            
        } else {
            return nil;
        }
    }
    
    return entries;
}

+ (NSArray *)search:(NSString *)query type:(int)type error:(NSError **)error {
    
    NSMutableArray  *entries    = [[[NSMutableArray alloc] init] autorelease];
    NSMutableString *requestUrl = [NSMutableString stringWithString:@""];
    
    NSLog(@"Remote API call: search-xml (type %d) '%@'", type, query);
    
    if (DARemoteSearchPrefix == type) {
        requestUrl = [NSMutableString stringWithString:@"http://dicionario-aberto.net/search-xml?prefix=%@"];
        
    } else if (DARemoteSearchSuffix == type) {
        requestUrl = [NSMutableString stringWithString:@"http://dicionario-aberto.net/search-xml?suffix=%@"];
        
    } else if (DARemoteSearchLike == type) {
        requestUrl = [NSMutableString stringWithString:@"http://dicionario-aberto.net/search-xml?like=%@"];
        
    } else {
        // TODO: Write to error and return
    }
    
    if ([query length]) {
        // Obtain definition from DicionarioAberto API
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:requestUrl, [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSString *result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
        CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:0 error:error];
    
        for (CXMLElement *ee in [doc nodesForXPath:@"//list/entry" error:nil]) {
            [entries addObject:[ee stringValue]];
        }
    
        [doc release];
    }
    
    return entries;
}

@end
