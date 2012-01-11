//
//  DefinitionCell.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 26/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "DARemoteClient.h"
#import "DAParser.h"

@interface SearchCell : UITableViewCell {
    IBOutlet UIView      *background;
    IBOutlet UILabel     *definitionIndex;
    IBOutlet UILabel     *definitionOrth;
    IBOutlet UILabel     *definitionText;
    IBOutlet UIImageView *errorImage;
    IBOutlet UILabel     *errorMessage;
}

@property (nonatomic, strong) IBOutlet UIView      *background;
@property (nonatomic, strong) IBOutlet UILabel     *definitionIndex;
@property (nonatomic, strong) IBOutlet UILabel     *definitionOrth;
@property (nonatomic, strong) IBOutlet UILabel     *definitionText;
@property (nonatomic, strong) IBOutlet UIImageView *errorImage;
@property (nonatomic, strong) IBOutlet UILabel     *errorMessage;

- (void)setContentAtRow:(NSUInteger)index using:(NSArray*)array;
- (void)setError:(NSString *)message type:(int)type;

@end
