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
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    // Obtain definition from DicionarioAberto API
    NSURL *url       = [NSURL URLWithString:[NSString stringWithFormat:@"http://dicionario-aberto.net/search-xml/%@",
                                             [word stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSString *result = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:error];
    
    // TODO: Error checking
    // TODO: Cache results
    
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:0 error:error];
    
    for (CXMLElement *ee in [doc nodesForXPath:@"//entry" error:nil]) {
        Entry *entry = [[Entry alloc] initFromXMLString:[ee XMLString] error:nil];
        
        if (entry)
            [entries addObject:entry];
        
        [entry release];
    }
    
    [doc release];
    
    return entries;
}

+ (NSArray *)searchWithPrefix:(NSString *)prefix {
    return nil;
}

+ (NSArray *)searchWithSuffix:(NSString *)suffix {
    return nil;
}

+ (NSArray *)searchSimilar:(NSString *)word {
    return nil;
}

@end
