//
//  DARemote.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "DARemote.h"

int const DARemoteGetEntry      = 0;
int const DARemoteSearchPrefix  = 1;
int const DARemoteSearchSuffix  = 2;
int const DARemoteSearchLike    = 3;

@implementation DARemote

// TODO: Connection error checking

+ (NSArray *)getEntries:(NSString *)query error:(NSError **)error {
    if ([query length] == 0)
        return nil;

    DASearchCache *cachedResponse;
    NSString *result;
    BOOL shouldCacheResult      = NO;
    NSMutableArray *entries     = [[[NSMutableArray alloc] init] autorelease];
    NSManagedObjectContext *moc = [(DADelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request     = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"DASearchCache" inManagedObjectContext:moc]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"searchQuery = %@ AND searchType = %d", query, DARemoteGetEntry]];
    [request setFetchLimit:1];
    
    NSArray *cachedResponses = [moc executeFetchRequest:request error:error];
    
    [request release];
    
    if (cachedResponses == nil) {
        NSLog(@"Error retrieving cached entry: %@", [*error userInfo]);
    }
    
    if (cachedResponses && [cachedResponses count]) {
        cachedResponse = (DASearchCache *)[cachedResponses lastObject];
        result = [cachedResponse searchResult];
        NSLog(@"Cached entry: '%@'", [cachedResponse searchQuery]);
        
    } else {
        // Obtain definition from DicionarioAberto API
        NSLog(@"Remote API call: search-xml '%@'", query);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://dicionario-aberto.net/search-xml/%@", [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
        shouldCacheResult = YES;
    }
    
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:0 error:error];
    
    for (CXMLElement *ee in [doc nodesForXPath:@"//entry" error:nil]) {
        Entry *entry = [[Entry alloc] initFromXMLString:[ee XMLString] error:nil];
        if (entry) [entries addObject:entry];
        [entry release];
    }
    
    [doc release];
    
    if (shouldCacheResult && [entries count]) {
        
        NSDate *now = [[NSDate alloc] init];
        
        cachedResponse = (DASearchCache *)[NSEntityDescription insertNewObjectForEntityForName:@"DASearchCache" inManagedObjectContext:moc];
        [cachedResponse setSearchQuery:query];
        [cachedResponse setSearchResult:result];
        [cachedResponse setSearchType:[NSNumber numberWithInt:DARemoteGetEntry]];
        [cachedResponse setSearchDate:now];
        
        if (![moc save:error]) {
            NSLog(@"Error caching '%@': %@", query, [*error userInfo]);
        }
        
        [now release];
    }
    
    return entries;
}


+ (NSArray *)search:(NSString *)query type:(int)type error:(NSError **)error {

    NSString *requestUrl;
    NSMutableArray  *entries = [[[NSMutableArray alloc] init] autorelease];

    if (DARemoteSearchPrefix == type) {
        requestUrl = @"http://dicionario-aberto.net/search-xml?prefix=%@";
        
    } else if (DARemoteSearchSuffix == type) {
        requestUrl = @"http://dicionario-aberto.net/search-xml?suffix=%@";
        
    } else if (DARemoteSearchLike == type) {
        requestUrl = @"http://dicionario-aberto.net/search-xml?like=%@";
        
    } else {
        return entries;
    }

    DASearchCache *cachedResponse;
    NSString *result;
    BOOL shouldCacheResult      = NO;
    NSManagedObjectContext *moc = [(DADelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request     = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"DASearchCache" inManagedObjectContext:moc]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"searchQuery = %@ AND searchType = %d", query, type]];
    [request setFetchLimit:1];
    
    NSArray *cachedResponses = [moc executeFetchRequest:request error:error];
    
    [request release];
    
    if (cachedResponses == nil) {
        NSLog(@"Error retrieving cached response (type %d): %@", type, [*error userInfo]);
    }
    
    if (cachedResponses && [cachedResponses count]) {
        cachedResponse = (DASearchCache *)[cachedResponses lastObject];
        result = [cachedResponse searchResult];
        NSLog(@"Cached search response (type %d): '%@'", type, [cachedResponse searchQuery]);
        
    } else {
        // Obtain definition from DicionarioAberto API
        NSLog(@"Remote API call: search-xml (type %d) '%@'", type, query);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:requestUrl, [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
        shouldCacheResult = YES;
    }        
    
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:0 error:error];
    
    for (CXMLElement *ee in [doc nodesForXPath:@"//list/entry" error:nil]) {
        [entries addObject:[ee stringValue]];
    }
    
    [doc release];
    
    if (shouldCacheResult && [entries count]) {
        
        NSDate *now = [[NSDate alloc] init];
        
        cachedResponse = (DASearchCache *)[NSEntityDescription insertNewObjectForEntityForName:@"DASearchCache" inManagedObjectContext:moc];
        [cachedResponse setSearchQuery:query];
        [cachedResponse setSearchResult:result];
        [cachedResponse setSearchType:[NSNumber numberWithInt:type]];
        [cachedResponse setSearchDate:now];
        
        if (![moc save:error]) {
            NSLog(@"Error caching search response (type %d) '%@': %@", type, query, [*error userInfo]);
        }
        
        [now release];
    }    
    
    return entries;
}


#pragma mark -
#pragma mark Caching

+ (NSString *)fetchCachedResultForQuery:(NSString *)query ofType:(int)type error:(NSError **)error {
    NSString * response;
    
    return response;
}


+ (void)cacheResult:(NSString *)result forQuery:(NSString *)query ofType:(int)type error:(NSError **)error {
    
}


@end
