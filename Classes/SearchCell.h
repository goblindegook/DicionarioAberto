//
//  DefinitionCell.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 26/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SearchCell : UITableViewCell {
    IBOutlet UILabel *definitionIndex;
    IBOutlet UILabel *definitionOrth;
    IBOutlet UILabel *definitionText;
    IBOutlet UIView *definitionBackground;
}

@property (nonatomic, retain) IBOutlet UILabel *definitionIndex;
@property (nonatomic, retain) IBOutlet UILabel *definitionOrth;
@property (nonatomic, retain) IBOutlet UILabel *definitionText;
@property (nonatomic, retain) IBOutlet UIView *definitionBackground;

@end
