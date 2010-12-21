//
//  SuperEntry.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "SuperEntry.h"

#import "Entry.h"

@implementation SuperEntry

@synthesize entry;

-(void) dealloc {
    [entry release];
    [super dealloc];
}

@end
