//
//  Entry.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "Entry.h"
#import "Form.h"
#import "Sense.h"
#import "Etym.h"

@implementation Entry

@synthesize n;
@synthesize entryId;
@synthesize entryType;
@synthesize entryForm;
@synthesize entrySense;
@synthesize entryEtym;

-(void) dealloc {
    [entryId release];
    [entryType release];
    [entryForm release];
    [entrySense release];
    [entryEtym release];
    [super dealloc];
}

@end
