//
//  Sense.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "Sense.h"
#import "Usage.h"

@implementation Sense

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
