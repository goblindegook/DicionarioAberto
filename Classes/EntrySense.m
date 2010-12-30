//
//  Sense.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "EntrySense.h"
#import "EntrySenseUsage.h"

@implementation EntrySense

@synthesize ast;
@synthesize def;
@synthesize gramGrp;
@synthesize usg;

-(void) dealloc {
    [def release];
    [gramGrp release];
    [usg release];
    [super dealloc];
}

@end
