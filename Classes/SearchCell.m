//
//  DefinitionCell.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 26/12/2010.
//

#import "SearchCell.h"

int const DASearchNoResults         = 1;
int const DASearchConnectionError   = 2;

@implementation SearchCell

@synthesize background;
@synthesize definitionIndex;
@synthesize definitionOrth;
@synthesize definitionText;
@synthesize errorImage;
@synthesize errorMessage;

- (void)setContentAtRow:(NSUInteger)index using:(NSArray*)array {
    
    NSString *cellEntry = [array objectAtIndex:index];
    NSInteger cellIndex = index - [array indexOfObject:cellEntry];
    
    self.definitionOrth.text = cellEntry;
    
    if (cellIndex || (index < [array count] - 1 && [cellEntry isEqual:[array objectAtIndex:index + 1]])) {
        cellIndex = cellIndex + 1;
    }
    
    if (cellIndex) {
        self.definitionIndex.hidden = NO;
        self.definitionIndex.text = [NSString stringWithFormat:@"%d", cellIndex];
        
    } else {
        self.definitionIndex.hidden = YES;
    }
}


- (void)setError:(NSString *)message type:(int)type {
    self.errorMessage.text = message;
    // TODO: Set image
}


- (void)dealloc {
    [super dealloc];
}

@end
