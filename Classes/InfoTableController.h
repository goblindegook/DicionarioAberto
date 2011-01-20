//
//  InfoController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 04/01/2011.
//

#import "DADelegate.h"
#import "InfoPageController.h"
#import "OBGradientView.h"

@interface InfoTableController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    DADelegate *delegate;
    IBOutlet OBGradientView *navBarShadow;
    IBOutlet UITableView *infoTableView;
    NSArray *infoTableContents;
}

@property (nonatomic, retain) IBOutlet UITableView *infoTableView;
@property (nonatomic, retain) NSArray *infoTableContents;

@end
