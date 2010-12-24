//
//  DicionarioAbertoViewController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import <UIKit/UIKit.h>

@interface RootController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    UITableView *searchResultsView;
    IBOutlet UISearchBar *searchBar;
    
    BOOL searching;
    BOOL letUserSelectRow;
}

@property (nonatomic, retain) IBOutlet UITableView *searchResultsView;

@end

