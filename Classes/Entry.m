//
//  Entry.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//


#import "Entry.h"
#import "DARemoteClient.h"
#import "AFKissXMLRequestOperation.h"
#import "DDXML.h"
#import "DDXMLNode+DAXMLNode.h"

@implementation Entry

@synthesize n;
@synthesize entryId;
@synthesize entryType;
@synthesize entryForm;
@synthesize entrySense;
@synthesize entryEtymology;

- (id)initWithXMLNode:(DDXMLElement *)node {
    self = [super init];
    
    if (self != nil) {
        self.entryForm       = [[EntryForm alloc] init];
        self.entryEtymology  = [[EntryEtymology alloc] init];
        self.entrySense      = [[NSMutableArray alloc] init];
        
        n               = [[[node attributeForName:@"n"] stringValue] integerValue];
        entryId         = [[[node attributeForName:@"id"] stringValue] mutableCopy];
        entryType       = [[[node attributeForName:@"type"] stringValue] mutableCopy];
        
        entryForm.orth  = [[[node nodeForXPath:@"./form/orth" error:nil] stringValue] mutableCopy];
        entryForm.phon  = [[[node nodeForXPath:@"./form/phon" error:nil] stringValue] mutableCopy];
        
        DDXMLElement *etymNode = (DDXMLElement *)[node nodeForXPath:@"./etym" error:nil];
        entryEtymology.text = [[etymNode stringValue] mutableCopy];
        entryEtymology.ori  = [[[etymNode attributeForName:@"ori"] stringValue] mutableCopy];
        
        for (DDXMLElement *senseNode in [node nodesForXPath:@"./sense" error:nil]) {
            EntrySense *sense = [[EntrySense alloc] init];
            
            sense.ast       = [[[senseNode attributeForName:@"ast"] stringValue] integerValue];
            sense.def       = [[[senseNode nodeForXPath:@"./def" error:nil] stringValue] mutableCopy];
            sense.gramGrp   = [[[senseNode nodeForXPath:@"./gramGrp" error:nil] stringValue] mutableCopy];
            
            DDXMLElement *usgNode = (DDXMLElement *)[senseNode nodeForXPath:@"./usg" error:nil];
            
            sense.usg.type  = [[[usgNode attributeForName:@"type"] stringValue] mutableCopy];
            sense.usg.text  = [[usgNode stringValue] mutableCopy];;
            
            [entrySense addObject:sense];
            
            sense = nil;
        }

        
    }

    return self;
}

+ (void)entryListWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [[DARemoteClient sharedClient] getPath:urlString parameters:mutableParameters success:^(__unused AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *mutableRecords = [NSMutableArray array];
        
        for (DDXMLElement *element in [responseObject nodesForXPath:@"/list/entry" error:nil]) {
            [mutableRecords addObject:[element stringValue]];
        }
        
        if (success) {
            success([NSArray arrayWithArray:mutableRecords]);
        }
        
        mutableRecords = nil;
        
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)entriesWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [[DARemoteClient sharedClient] getPath:urlString parameters:mutableParameters success:^(__unused AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *mutableRecords = [NSMutableArray array];
        
        for (DDXMLElement *node in [responseObject nodesForXPath:@"//entry" error:nil]) {
            Entry *entry = [[Entry alloc] initWithXMLNode:node];
            [mutableRecords addObject:entry];
        }
        
        if (success) {
            success([NSArray arrayWithArray:mutableRecords]);
        }
        
        mutableRecords = nil;
        
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
