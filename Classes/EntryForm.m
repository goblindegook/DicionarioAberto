//
//  Form.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "EntryForm.h"


@implementation EntryForm

@synthesize orth;
@synthesize phon;

-(void) dealloc {
    [orth release];
    [phon release];
    [super dealloc];
}

@end
