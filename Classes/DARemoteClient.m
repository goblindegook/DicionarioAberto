//
//  DARemote.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//

#import "DARemoteClient.h"
#import "AFKissXMLRequestOperation.h"

int const DARemoteGetEntry      = 0;
int const DARemoteSearchPrefix  = 1;
int const DARemoteSearchSuffix  = 2;
int const DARemoteSearchLike    = 3;

int const DARemoteSearchOK           = 1;
int const DARemoteSearchWait         = 2;
int const DARemoteSearchEmpty        = 0;
int const DARemoteSearchNoConnection = -1;
int const DARemoteSearchUnavailable  = -2;

NSString * const kDARemoteBaseURLString = @"http://dicionario-aberto.net/";

@implementation DARemoteClient

+ (DARemoteClient *)sharedClient {
    static DARemoteClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kDARemoteBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFKissXMLRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/xml"];
    	
	// X-UDID HTTP Header
	[self setDefaultHeader:@"X-UDID" value:[[UIDevice currentDevice] uniqueIdentifier]];
    
    return self;
}

@end
