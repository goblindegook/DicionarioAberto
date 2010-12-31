//
//  DARemote.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

#import "DADelegate.h"
#import "DASearchCache.h"
#import "Entry.h"

extern int const DARemoteSearchPrefix;
extern int const DARemoteSearchSuffix;
extern int const DARemoteSearchLike;

@interface DARemote : NSObject {

}

+ (NSArray *)getEntries:(NSString *)query error:(NSError **)error;
+ (NSArray *)search:(NSString *)query type:(int)type error:(NSError **)error;

+ (NSString *)fetchCachedResultForQuery:(NSString *)query ofType:(int)type error:(NSError **)error;
+ (void)cacheResult:(NSString *)result forQuery:(NSString *)query ofType:(int)type error:(NSError **)error;

@end
