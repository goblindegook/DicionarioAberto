//
//  Entry.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//


#import "Entry.h"
#import "DARemoteClient.h"
#import "AFHTTPRequestOperation.h"

@implementation Entry

@synthesize n;
@synthesize entryId;
@synthesize entryType;
@synthesize entryForm;
@synthesize entrySense;
@synthesize entryEtymology;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    
    if (self != nil) {
        self.entryForm       = [[EntryForm alloc] init];
        self.entryEtymology  = [[EntryEtymology alloc] init];
        self.entrySense      = [[NSMutableArray alloc] init];
    }

    return self;
}

// Initializes one Entry object from an XML string
    
    
    /*
    
    n               = [[[entryNode attributeForName:@"n"] stringValue] integerValue];
    entryId         = [[[entryNode attributeForName:@"id"] stringValue] mutableCopy];
    entryType       = [[[entryNode attributeForName:@"type"] stringValue] mutableCopy];
    
    entryForm.orth  = [[[entryNode nodeForXPath:@"./form/orth" error:nil] stringValue] mutableCopy];
    entryForm.phon  = [[[entryNode nodeForXPath:@"./form/phon" error:nil] stringValue] mutableCopy];

    CXMLElement *etymNode = (CXMLElement *)[entryNode nodeForXPath:@"./etym" error:nil];
    
    entryEtymology.text = [[etymNode stringValue] mutableCopy];
    entryEtymology.ori  = [[[etymNode attributeForName:@"ori"] stringValue] mutableCopy];
    
    for (CXMLElement *senseNode in [entryNode nodesForXPath:@"./sense" error:nil]) {
        EntrySense *sense = [[EntrySense alloc] init];
        
        sense.ast       = [[[senseNode attributeForName:@"ast"] stringValue] integerValue];
        sense.def       = [[[senseNode nodeForXPath:@"./def" error:nil] stringValue] mutableCopy];
        sense.gramGrp   = [[[senseNode nodeForXPath:@"./gramGrp" error:nil] stringValue] mutableCopy];
        
        CXMLElement *usgNode = (CXMLElement *)[senseNode nodeForXPath:@"./usg" error:nil];
        
        sense.usg.type  = [[[usgNode attributeForName:@"type"] stringValue] mutableCopy];
        sense.usg.text  = [[usgNode stringValue] mutableCopy];;
        
        [entrySense addObject:sense];
        
        sense = nil;
    }

    doc = nil;
     */


+ (void)entriesWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    [[DARemoteClient sharedClient] getPath:urlString parameters:mutableParameters success:^(__unused AFHTTPRequestOperation *operation, id response) {
        NSMutableArray *mutableRecords = [NSMutableArray array];

        NSLog(@"%@", operation.request);
        NSLog(@"%@", operation.responseString);
        NSLog(@"%@", response);
        
        /*
        if ([response valueForKey:@"list"] != nil) {
            for (NSString *entry in [response valueForKeyPath:@"list"]) {
                [mutableRecords addObject:entry];
            }
        } else if ([response valueForKey:@"entry"] != nil) {
            Entry *entry = [[Entry alloc] initWithAttributes:[response valueForKey:@"entry"]];
            [mutableRecords addObject:entry];
        } else {
            for (NSDictionary *attributes in [response valueForKey:@"superEntry"]) {
                Entry *entry = [[Entry alloc] initWithAttributes:[attributes valueForKey:@"entry"]];
                [mutableRecords addObject:entry];
            }
        }
        */
        
        if (success) {
            success([NSArray arrayWithArray:mutableRecords]);
        }
    } failure:^(__unused AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
