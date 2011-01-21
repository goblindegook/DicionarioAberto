//
//  DefinitionCell.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 26/12/2010.
//

#import "SearchCell.h"

@implementation SearchCell

@synthesize background;
@synthesize definitionIndex;
@synthesize definitionOrth;
@synthesize definitionText;
@synthesize errorImage;
@synthesize errorMessage;

#pragma mark Instance Methods

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
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:128 green:0 blue:0 alpha:1];
        
    } else {
        self.definitionIndex.hidden = YES;
    }
}


- (void)setError:(NSString *)message type:(int)type {
    self.errorMessage.text = message;
    
    if (DARemoteSearchWait == type) {
        self.errorImage.image = [UIImage imageNamed:@"Images/IconWait.png"];
        
    } else if (DARemoteSearchEmpty == type) {
        self.errorImage.image = [UIImage imageNamed:@"Images/IconError.png"];
        
    } else if (DARemoteSearchNoConnection == type) {
        self.errorImage.image = [UIImage imageNamed:@"Images/IconError.png"];
    }
}


- (void)dealloc {
    [super dealloc];
}

@end
