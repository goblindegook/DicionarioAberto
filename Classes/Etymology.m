//
//  Etymology.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "Etymology.h"

@implementation Etymology

@synthesize ori;
@synthesize text;

-(void) dealloc {
    [ori release];
    [text release];
    [super dealloc];
}

@end
