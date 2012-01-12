//
//  DicionarioAbertoViewController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

@interface DASearchController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate> {

@private
    UISearchBar *_searchBar;
    UITableView *_searchResultsTable;
    NSArray *_searchResults;
    int _searchStatus;
    BOOL _searchPrefix;
    BOOL _letUserSelectRow;
    BOOL _searchShouldBeginEditing;
}

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *searchResultsTable;

- (void)searchDicionarioAberto:(NSString *)query;
- (void)reloadSearchResultsTable;
- (void)showInfoTable;
- (void)dismissSearch;
- (void)keyboardDidShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;

@end

