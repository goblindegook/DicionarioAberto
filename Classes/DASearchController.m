//
//  DicionarioAbertoViewController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import "DASearchController.h"
#import "DARemoteClient.h"
#import "Entry.h"
#import "SearchCell.h"
#import "DefinitionController.h"
#import "InfoTableController.h"
#import "SVProgressHUD.h"

@implementation DASearchController

@synthesize searchBar           = _searchBar;
@synthesize searchResultsTable  = _searchResultsTable;

#pragma mark - Instance Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Dicionário Aberto";
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showInfoTable) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    
    _searchShouldBeginEditing       = YES;
    _searchPrefix                   = YES;
    _letUserSelectRow               = YES;
    _searchStatus                   = DARemoteSearchOK;
    
    // TODO: Customize searchBar
    
    _searchBar.showsScopeBar        = NO;
    _searchBar.showsCancelButton    = NO;
    [_searchBar sizeToFit];
    
    UITapGestureRecognizer *dismissSearchTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSearch)];
    dismissSearchTapGesture.cancelsTouchesInView = NO;
    [_searchResultsTable addGestureRecognizer:dismissSearchTapGesture];
    dismissSearchTapGesture = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    _searchBar = nil;
    _searchResultsTable = nil;
    _searchResults = nil;
}


- (void)dismissSearch {
    [_searchBar resignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(_searchResultsTable.contentInset.top, 0.0, kbSize.height, 0.0);
    _searchResultsTable.contentInset = contentInsets;
    _searchResultsTable.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(_searchResultsTable.contentInset.top, 0.0, 0.0, 0.0);
    _searchResultsTable.contentInset = contentInsets;
    _searchResultsTable.scrollIndicatorInsets = contentInsets;
}


- (void)searchDicionarioAberto:(NSString *)query {
    
    //[[DARemoteClient sharedClient] cancelHTTPOperationsWithMethod:@"GET" andURL:[NSURL URLWithString:@"/search-xml"]];
    
    if ([query length] > 0) {
        [SVProgressHUD show];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObject:query forKey:(_searchPrefix) ? @"prefix" : @"suffix"];
        
        [Entry entryListWithURLString:@"/search-xml"
                           parameters:parameters
                              success:^(NSArray *records) {
                                  _searchResults = records;
                                  _searchStatus = [_searchResults count] ? DARemoteSearchOK : DARemoteSearchEmpty;
                                  _letUserSelectRow = [_searchResults count];
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self reloadSearchResultsTable];
                                      [SVProgressHUD dismiss];
                                  });
                              }
                              failure:^(NSError *error) {
                                  NSLog(@"%@", error);
                                  
                                  _letUserSelectRow = NO;
                                  _searchStatus = DARemoteSearchNoConnection;
                                  _searchStatus = DARemoteSearchUnavailable;
                                  _searchResults = [NSArray arrayWithObjects:nil];
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self reloadSearchResultsTable];
                                      [SVProgressHUD dismissWithError:NSLocalizedString(@"HUDErrorGeneral", @"General HUD error")];
                                  });
                              }
         ];
        
    } else {
        _searchStatus           = DARemoteSearchOK;
        _letUserSelectRow       = NO;
        _searchResults          = [NSArray array];
        
        [self reloadSearchResultsTable];
    }
}


- (void)reloadSearchResultsTable {
    _letUserSelectRow = (DARemoteSearchOK == _searchStatus);
    _searchResultsTable.scrollEnabled = (DARemoteSearchOK == _searchStatus);

    [_searchResultsTable reloadData];
    
    if ([_searchResults count]) {
        [_searchResultsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    NSLog(@"Frame: %@", NSStringFromCGRect(_searchResultsTable.frame));
    NSLog(@"Inset: %@", NSStringFromUIEdgeInsets(_searchResultsTable.contentInset));
    NSLog(@"Offset: %@", NSStringFromCGPoint(_searchResultsTable.contentOffset));
}


- (void)showInfoTable {
    InfoTableController *infoTable = [[InfoTableController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pesquisa" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationController pushViewController:infoTable animated:YES];
}


#pragma mark - UISearchBarDelegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:0.4f animations:^{
        CGFloat heightDelta = -searchBar.frame.size.height;
        [searchBar setShowsScopeBar:YES];
        [searchBar sizeToFit];
        heightDelta += searchBar.frame.size.height;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(heightDelta, 0.0, _searchResultsTable.contentInset.bottom, 0.0);
        _searchResultsTable.contentInset = contentInsets;
        _searchResultsTable.scrollIndicatorInsets = contentInsets;
        
        CGPoint scrollPoint = CGPointMake(0.0, -heightDelta);
        [_searchResultsTable setContentOffset:scrollPoint animated:YES];
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [UIView animateWithDuration:0.4f animations:^{
        [searchBar setShowsScopeBar:NO];
        [searchBar sizeToFit];
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, _searchResultsTable.contentInset.bottom, 0.0);
        _searchResultsTable.contentInset = contentInsets;
        _searchResultsTable.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] == 0) {
        _searchShouldBeginEditing = [searchBar isFirstResponder];
    }
    [self searchDicionarioAberto:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    //[self searchDicionarioAberto:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    _searchPrefix = (selectedScope == 0);
    [self searchDicionarioAberto:searchBar.text];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)aSearchBar {
    BOOL decision = _searchShouldBeginEditing;
    _searchShouldBeginEditing = YES;
    return decision;
}

#pragma mark - UITableViewDataSource Methods


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier;
    static NSString *cellNib;
    
    if (DARemoteSearchOK == _searchStatus) {
        cellIdentifier  = @"searchCell";
        cellNib         = @"SearchCell";
        
    } else {
        cellIdentifier  = @"errorCell";
        cellNib         = @"SearchErrorCell";
    }
    
    SearchCell *cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell){
       NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellNib owner:nil options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[SearchCell class]])
            {
                cell = (SearchCell *)currentObject;
                break;
            }
        }
    }
    
    if (DARemoteSearchNoConnection == _searchStatus) {
        [cell setError:@"Erro de ligação" type:_searchStatus];

    } else if (DARemoteSearchUnavailable == _searchStatus) {
        [cell setError:@"Indisponível" type:_searchStatus];
        
    } else if (DARemoteSearchEmpty == _searchStatus) {
        [cell setError:@"Sem resultados" type:_searchStatus];

    } else if (DARemoteSearchWait == _searchStatus) {
        [cell setError:@"Aguarde" type:_searchStatus];
        
    } else if (DARemoteSearchOK == _searchStatus) {
        [cell setContentAtRow:indexPath.row using:_searchResults];

    } else {
        [cell setError:@"Desconhecido" type:_searchStatus];
    }

    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (_searchResults != nil) {
        return (DARemoteSearchOK == _searchStatus) ? [_searchResults count] : 1;
        
    } else {
        return 0;
    }
}


#pragma mark -
#pragma mark UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (DARemoteSearchOK != _searchStatus) {
        return (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
            ? tableView.frame.size.height
            : tableView.frame.size.height + 44;
        
    } else {
        return 44;
    }
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return _letUserSelectRow ? indexPath : nil;
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *query = [_searchResults objectAtIndex:indexPath.row];
    NSInteger first = [_searchResults indexOfObject:query];
    NSInteger n     = (first > indexPath.row) ? 0 : indexPath.row - first + 1;
    
    DefinitionController *definition = [[DefinitionController alloc] initWithRequest:query atIndex:n];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pesquisa" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationController pushViewController:definition animated:YES];
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    //self.navigationItem.backBarButtonItem;
}

@end
