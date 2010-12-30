//
//  Etymology.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "EntryEtymology.h"

@implementation EntryEtymology

@synthesize ori;
@synthesize text;

-(void) dealloc {
    [ori release];
    [text release];
    [super dealloc];
}

@end
