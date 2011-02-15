//
//  DARemote.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//

#import "DADelegate.h"
#import "DASearchCache.h"

extern int const DARemoteGetEntry;
extern int const DARemoteSearchPrefix;
extern int const DARemoteSearchSuffix;
extern int const DARemoteSearchLike;

extern int const DARemoteSearchOK;
extern int const DARemoteSearchWait;
extern int const DARemoteSearchEmpty;
extern int const DARemoteSearchNoConnection;
extern int const DARemoteSearchUnavailable;

@protocol DARemoteDelegate;

@interface DARemote : NSObject {
    id <DARemoteDelegate> delegate;
    NSMutableData *receivedData;
    NSDate *lastModified;
    NSInteger statusCode;
    NSURLConnection *connection;    
    NSString *query;
    int type;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSDate *lastModified;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, retain) NSString *query;
@property (assign, readwrite) int type;

- (id)initWithQuery:(NSString *)query ofType:(int)type delegate:(id<DARemoteDelegate>)theDelegate;
- (void)cancel;

+ (NSString *)fetchCachedResultForQuery:(NSString *)query ofType:(int)type error:(NSError **)error;
+ (BOOL)cacheResult:(NSString *)result forQuery:(NSString *)query ofType:(int)type error:(NSError **)error;
+ (BOOL)deleteCacheOlderThan:(NSDate *)date error:(NSError **)error;

@end

@protocol DARemoteDelegate<NSObject>

- (void) connectionDidFail:(DARemote *)theConnection;
- (void) connectionDidFinish:(DARemote *)theConnection;

@end
