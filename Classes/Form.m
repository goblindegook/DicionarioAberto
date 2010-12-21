//
//  Form.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "Form.h"


@implementation Form

@synthesize orth;

-(void) dealloc {
    [orth release];
    [super dealloc];
}

@end
