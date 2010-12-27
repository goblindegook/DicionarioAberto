//
//  DicionarioAbertoViewController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import <UIKit/UIKit.h>

@interface RootController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate> {
    
    UITableView *searchResultsView;
    
    UISearchDisplayController *searchDisplayController;
    
    //IBOutlet UISearchBar *searchBar;
    
    BOOL searchPrefix;
    BOOL searching;
    BOOL letUserSelectRow;
}

@property (nonatomic, retain) IBOutlet UITableView *searchResultsView;

- (void) changeScopeDicionarioAberto:(NSInteger)selectedScope;
- (void) searchDicionarioAberto:(NSString *)searchText;

@end

