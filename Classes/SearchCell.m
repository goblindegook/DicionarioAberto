//
//  DefinitionCell.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 26/12/2010.
//

#import "SearchCell.h"

@implementation SearchCell

@synthesize definitionIndex;
@synthesize definitionOrth;
@synthesize definitionText;
@synthesize definitionBackground;

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

@end
