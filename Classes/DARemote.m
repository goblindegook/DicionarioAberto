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
    return [DARemote search:query type:DARemoteGetEntry error:error];
}


+ (NSArray *)search:(NSString *)query type:(int)type error:(NSError **)error {

    if ([query length] == 0)
        return nil;
    
    NSString *requestUrl;
    NSString *xPath;

    if (DARemoteGetEntry == type) {
        requestUrl  = @"http://dicionario-aberto.net/search-xml/%@";
        xPath       = @"//entry";
        
    } else if (DARemoteSearchPrefix == type) {
        requestUrl  = @"http://dicionario-aberto.net/search-xml?prefix=%@";
        xPath       = @"//list/entry";
        
    } else if (DARemoteSearchSuffix == type) {
        requestUrl  = @"http://dicionario-aberto.net/search-xml?suffix=%@";
        xPath       = @"//list/entry";
        
    } else if (DARemoteSearchLike == type) {
        requestUrl  = @"http://dicionario-aberto.net/search-xml?like=%@";
        xPath       = @"//list/entry";
        
    } else {
        return nil;
    }

    BOOL shouldCacheResult = NO;
    NSMutableArray *entries = [[[NSMutableArray alloc] init] autorelease];

    NSString *result;
    
    result = [DARemote fetchCachedResultForQuery:query ofType:type error:error];
    
    if (result == nil) {
        // Obtain definition from DicionarioAberto API
        NSLog(@"Remote API call: search-xml '%@' (type %d)", query, type);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:requestUrl, [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
        shouldCacheResult = YES;
    }
    
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:0 error:error];
    
    for (CXMLElement *ee in [doc nodesForXPath:xPath error:nil]) {
        if (type == DARemoteGetEntry) {
            Entry *entry = [[Entry alloc] initFromXMLString:[ee XMLString] error:nil];
            if (entry) [entries addObject:entry];
            [entry release];
        } else {
            [entries addObject:[ee stringValue]];            
        }
    }
    
    [doc release];
    
    if (shouldCacheResult && [entries count]) {
        [DARemote cacheResult:(NSString *)result forQuery:(NSString *)query ofType:(int)type error:(NSError **)error];
    }
    
    return entries;
}


#pragma mark -
#pragma mark Caching


+ (NSString *)fetchCachedResultForQuery:(NSString *)query ofType:(int)type error:(NSError **)error {
    NSManagedObjectContext *moc = [(DADelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request     = [[NSFetchRequest alloc] init];
    NSString *response          = nil;
    
    [request setEntity:[NSEntityDescription entityForName:@"DASearchCache" inManagedObjectContext:moc]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"searchQuery = %@ AND searchType = %d", query, type]];
    [request setFetchLimit:1];
    
    NSArray *cachedResponses = [moc executeFetchRequest:request error:error];
    
    [request release];
    
    if (cachedResponses == nil) {
        NSLog(@"Error fetching cached response '%@' (type %d): %@", query, type, [*error userInfo]);
        
    } else if ([cachedResponses count] > 0) {
        DASearchCache *cache = (DASearchCache *)[cachedResponses lastObject];
        NSLog(@"Fetched cached response '%@' (type %d)", [cache searchQuery], type);
        response = [cache searchResult];
    }
    
    return response;
}


+ (BOOL)cacheResult:(NSString *)result forQuery:(NSString *)query ofType:(int)type error:(NSError **)error {
    NSManagedObjectContext *moc = [(DADelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSDate *now                 = [[NSDate alloc] init];
    BOOL success                = YES;
    
    DASearchCache *cachedResponse = (DASearchCache *)[NSEntityDescription insertNewObjectForEntityForName:@"DASearchCache" inManagedObjectContext:moc];
    
    [cachedResponse setSearchQuery:query];
    [cachedResponse setSearchResult:result];
    [cachedResponse setSearchType:[NSNumber numberWithInt:type]];
    [cachedResponse setSearchDate:now];
    
    if (![moc save:error]) {
        NSLog(@"Error caching search response (type %d) '%@': %@", type, query, [*error userInfo]);
        success = NO;
    }
    
    [now release];
    
    return success;
}


+ (BOOL)deleteCacheOlderThan:(NSDate *)date {
    // TODO
    return YES;
}


@end
