//
//  DicionarioAbertoViewController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import <UIKit/UIKit.h>

@interface RootController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *searchResultsView;
}

@property (nonatomic, retain) IBOutlet UITableView *searchResultsView;

@end

