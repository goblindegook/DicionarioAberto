//
//  DARemote.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 23/12/2010.
//

#import "DARemote.h"

int const DARemoteGetEntry      = 0;
int const DARemoteSearchPrefix  = 1;
int const DARemoteSearchSuffix  = 2;
int const DARemoteSearchLike    = 3;

int const DARemoteSearchOK           = 1;
int const DARemoteSearchEmpty        = 0;
int const DARemoteSearchNoConnection = -1;

@implementation DARemote

@synthesize delegate;
@synthesize receivedData;
@synthesize lastModified;
@synthesize connection;
@synthesize query;
@synthesize type;


- (id)initWithQuery:(NSString *)theQuery ofType:(int)theType delegate:(id<DARemoteDelegate>)theDelegate {
    if (self = [super init]) {
        self.query      = theQuery;
        self.type       = theType;
        self.delegate   = theDelegate;
        
        NSString *urlFormat;
        
        if (DARemoteGetEntry == theType) {
            urlFormat = @"http://dicionario-aberto.net/search-xml/%@";
        } else if (DARemoteSearchPrefix == theType) {
            urlFormat = @"http://dicionario-aberto.net/search-xml?prefix=%@";
        } else if (DARemoteSearchSuffix == theType) {
            urlFormat = @"http://dicionario-aberto.net/search-xml?suffix=%@";
        } else if (DARemoteSearchLike == theType) {
            urlFormat = @"http://dicionario-aberto.net/search-xml?like=%@";
        } else {
            return nil;
        }
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:urlFormat, [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        NSLog(@"Remote API call: %@", [url absoluteURL]);
        
        // Change to NSURLRequestUseProtocolCachePolicy later
        
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:url
                                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                timeoutInterval:10];
        
        if (DARemoteGetEntry == theType) {
            self.connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];            
        } else {
            // Delayed request
            self.connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:NO];
            [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [NSTimer scheduledTimerWithTimeInterval:0.2 target:self.connection selector:@selector(start) userInfo:nil repeats:NO];            
        }
        
        if (self.connection == nil) {
            // Connection error
            return self;
        }
    }
    
    return self;
}


- (void)dealloc {
    if (connection != nil) {
        [connection cancel];
    }
    [connection release];
    [query release];
    [receivedData release];
    [lastModified release];
    [super dealloc];
}


#pragma mark NSURLConnection delegate methods


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    /* This method is called when the server has determined that it has
     enough information to create the NSURLResponse. It can be called
     multiple times, for example in the case of a redirect, so each time
     we reset the data capacity. */
    
    /* create the NSMutableData instance that will hold the received data */
    
    long long contentLength = [response expectedContentLength];
    if (contentLength == NSURLResponseUnknownLength) {
        contentLength = 500000;
    }
    self.receivedData = [NSMutableData dataWithCapacity:(NSUInteger)contentLength];
    
    /* Try to retrieve last modified date from HTTP header. If found, format
     date so it matches format of cached image file modification date. */
    
    if ([response isKindOfClass:[NSHTTPURLResponse self]]) {
        NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
        NSString *modified = [headers objectForKey:@"Last-Modified"];
        if (modified) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            /* avoid problem if the user's locale is incompatible with HTTP-style dates */
            [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
            
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
            self.lastModified = [dateFormatter dateFromString:modified];
            [dateFormatter release];
        }
        else {
            /* default if last modified date doesn't exist (not an error) */
            self.lastModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
        }
    }
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    /* Append the new data to the received data. */
    [self.receivedData appendData:data];
}


- (NSCachedURLResponse *) connection:(NSURLConnection *)connection
                   willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    /* this application does not use a NSURLCache disk or memory cache */
    return nil;
}


- (void)cancel {
    NSLog(@"Cancelling request for '%@'", self.query);
    [connection cancel];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate connectionDidFail:self];
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate connectionDidFinish:self];
}


#pragma mark Caching

+ (NSString *)fetchCachedResultForQuery:(NSString *)query ofType:(int)type error:(NSError **)error {
    assert([NSThread isMainThread]);
    
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
        
        NSDate *now = [[NSDate alloc] init];
        [cache setSearchDate:now];
        [now release];
        
        if (![moc save:error]) {
            NSLog(@"Error updating cached search response (type %d) '%@': %@", type, query, [*error userInfo]);
        }
    }
    
    return response;
}


+ (BOOL)cacheResult:(NSString *)theResult forQuery:(NSString *)theQuery ofType:(int)theType error:(NSError **)error {
    assert([NSThread isMainThread]);
    
    NSManagedObjectContext *moc = [(DADelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSDate *now                 = [[NSDate alloc] init];
    BOOL success                = YES;
    
    NSLog(@"Caching search response (type %d) '%@'", theType, theQuery);
    
    DASearchCache *cachedResponse = (DASearchCache *)[NSEntityDescription insertNewObjectForEntityForName:@"DASearchCache" inManagedObjectContext:moc];
    
    [cachedResponse setSearchQuery:theQuery];
    [cachedResponse setSearchResult:theResult];
    [cachedResponse setSearchType:[NSNumber numberWithInt:theType]];
    [cachedResponse setSearchDate:now];
    
    if (![moc save:error]) {
        NSLog(@"Error caching search response (type %d) '%@': %@", theType, theQuery, [*error userInfo]);
        success = NO;
    }
    
    [now release];
    
    return success;
}


+ (BOOL)deleteCacheOlderThan:(NSDate *)date error:(NSError **)error {
    assert([NSThread isMainThread]);
    
    NSManagedObjectContext *moc = [(DADelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *request     = [[NSFetchRequest alloc] init];
    BOOL success                = YES;
    
    [request setEntity:[NSEntityDescription entityForName:@"DASearchCache" inManagedObjectContext:moc]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"searchDate < %@", date]];
    [request setIncludesPropertyValues:NO];
    
    NSArray *cache = [moc executeFetchRequest:request error:error];
    
    [request release];
    
    if (cache == nil) {
        NSLog(@"Error obtaining cache elements to delete: %@", [*error userInfo]);
        success = NO;
        
    } else {
        for (NSManagedObject *cachedRequest in cache) {
            [moc deleteObject:cachedRequest];
        }
    }
    
    return success;
}


@end
