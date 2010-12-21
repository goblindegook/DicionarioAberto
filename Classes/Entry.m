//
//  Entry.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "Entry.h"
#import "Form.h"
#import "Sense.h"
#import "Etymology.h"

@implementation Entry

@synthesize n;
@synthesize entryId;
@synthesize entryType;
@synthesize entryForm;
@synthesize entrySense;
@synthesize entryEtymology;

-(void) dealloc {
    [entryId release];
    [entryType release];
    [entryForm release];
    [entrySense release];
    [entryEtymology release];
    [super dealloc];
}

@end
