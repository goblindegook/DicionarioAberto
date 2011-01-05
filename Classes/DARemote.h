//
//  DARemote.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
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
+ (BOOL)cacheResult:(NSString *)result forQuery:(NSString *)query ofType:(int)type error:(NSError **)error;
+ (BOOL)deleteCacheOlderThan:(NSDate *)date error:(NSError **)error;

@end
