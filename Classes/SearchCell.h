//
//  DefinitionCell.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 26/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "DARemote.h"
#import "DAParser.h"

@interface SearchCell : UITableViewCell {
    IBOutlet UIView      *background;
    IBOutlet UILabel     *definitionIndex;
    IBOutlet UILabel     *definitionOrth;
    IBOutlet UILabel     *definitionText;
    IBOutlet UIImageView *errorImage;
    IBOutlet UILabel     *errorMessage;
}

@property (nonatomic, retain) IBOutlet UIView      *background;
@property (nonatomic, retain) IBOutlet UILabel     *definitionIndex;
@property (nonatomic, retain) IBOutlet UILabel     *definitionOrth;
@property (nonatomic, retain) IBOutlet UILabel     *definitionText;
@property (nonatomic, retain) IBOutlet UIImageView *errorImage;
@property (nonatomic, retain) IBOutlet UILabel     *errorMessage;

- (void)setContentAtRow:(NSUInteger)index using:(NSArray*)array;
- (void)setError:(NSString *)message type:(int)type;

@end
