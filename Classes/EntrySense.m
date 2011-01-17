//
//  Sense.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "EntrySense.h"

@implementation EntrySense

@synthesize ast;
@synthesize def;
@synthesize gramGrp;
@synthesize usg;

-(void) dealloc {
    [usg release];
    [def release];
    [gramGrp release];
    [super dealloc];
}

@end
