//
//  Usage.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
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
