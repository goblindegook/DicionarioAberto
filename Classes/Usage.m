//
//  Usage.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "Usage.h"


@implementation Usage

@synthesize type;
@synthesize text;

-(void) dealloc {
    [type release];
    [text release];
    [super dealloc];
}

@end
