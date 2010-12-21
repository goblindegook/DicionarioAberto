//
//  Etym.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "Etym.h"

@implementation Etym

@synthesize ori;
@synthesize text;

-(void) dealloc {
    [ori release];
    [text release];
    [super dealloc];
}

@end
