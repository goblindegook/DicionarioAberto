//
//  Entry.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//


#import "Entry.h"

@implementation Entry

@synthesize n;
@synthesize entryId;
@synthesize entryType;
@synthesize entryForm;
@synthesize entrySense;
@synthesize entryEtymology;

// Initializes one Entry object from an XML string
- (id)initFromXMLString:(NSString *)xml error:(NSError **)error {
    
    entryForm       = [[EntryForm alloc] init];
    entryEtymology  = [[EntryEtymology alloc] init];
    entrySense      = [[NSMutableArray alloc] init];
    
    CXMLDocument *doc = [[CXMLDocument alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding] options:0 error:error];
    
    CXMLElement *entryNode = (CXMLElement *)[doc nodeForXPath:@"//entry" error:nil];
    
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
        
        [sense release];
    }
    
    [doc release];
    
    return self;
}

- (void) dealloc {
    [entryId release];
    [entryType release];
    [entryForm release];
    [entrySense release];
    [entryEtymology release];
    [super dealloc];
}

@end
