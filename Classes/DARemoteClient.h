//
//  DARemote.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//

#import "AFHTTPClient.h"

extern int const DARemoteGetEntry;
extern int const DARemoteSearchPrefix;
extern int const DARemoteSearchSuffix;
extern int const DARemoteSearchLike;

extern int const DARemoteSearchOK;
extern int const DARemoteSearchWait;
extern int const DARemoteSearchEmpty;
extern int const DARemoteSearchNoConnection;
extern int const DARemoteSearchUnavailable;

extern NSString * const kDARemoteBaseURLString;

@interface DARemoteClient : AFHTTPClient {
}

+ (DARemoteClient *)sharedClient;

@end
