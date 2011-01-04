//
//  InfoController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 04/01/2011.
//

#import <UIKit/UIKit.h>
#import "DADelegate.h"

@interface InfoTableController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    DADelegate *delegate;
    UITableView *infoTableView;
}

@property (nonatomic, retain) IBOutlet UITableView *infoTableView;

@end
