//
//  DicionarioAbertoViewController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import "RootController.h"

@implementation RootController

@synthesize searchResultsTable;

#pragma mark Instance Methods

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    self.title = @"Dicionário Aberto";
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showInfoTable) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
    
    searchResultsTable.hidden   = YES;

    searchPrefix        = YES;
    searching           = NO;
    letUserSelectRow    = YES;
    searchStatus        = DARemoteSearchOK;
    
    NSDate *cutoff = [[NSDate alloc] initWithTimeIntervalSinceNow:(-3600 * 24 * 2)]; // 2d
    
    // NSDate *cutoff = [[NSDate alloc] initWithTimeIntervalSinceNow:(-300)]; // 5m
    
    [DARemote deleteCacheOlderThan:cutoff error:nil];
    
    [cutoff release];
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [connection release];
    [searchResultsTable release];
    [tableHeaderView release];
    [tableFooterView release];
    [super dealloc];
}


- (void)dropShadowFor:(UITableView *)tableView enabled:(BOOL)enabled {
    
    if (enabled) {
        
        if (tableHeaderView == nil && tableFooterView == nil) {
            UIColor *light = (id)[tableView.backgroundColor colorWithAlphaComponent:0.0].CGColor;
            UIColor *darkH = (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor;
            UIColor *darkF = (id)[UIColor colorWithWhite:0 alpha:0.5].CGColor;
            
            tableHeaderView = [[OBGradientView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
            tableHeaderView.colors = [NSArray arrayWithObjects:(id)light, (id)darkH, nil];
            tableHeaderView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
            
            tableFooterView = [[OBGradientView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
            tableFooterView.colors = [NSArray arrayWithObjects:(id)darkF, (id)light, nil];
            tableFooterView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        }
        
        tableView.tableHeaderView = tableHeaderView;
        tableView.tableFooterView = tableFooterView;
        
        [tableView setContentInset:UIEdgeInsetsMake(-20, 0, -20, 0)];
        
    } else {
        tableView.tableHeaderView = nil;
        tableView.tableFooterView = nil;
        
        [tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}


- (void)searchDicionarioAberto:(NSString *)query {
    
    if ([query length] > 0) {
        searching = YES;
        
        BOOL searchSaved = (searchPrefix && [delegate.savedSearchText length] && [query hasPrefix:delegate.savedSearchText]);
        
        if (connection != nil) {
            connection.cancel;
            [connection release];
            connection = nil;
        }
        
        if (searchSaved && searchPrefix) {
            // Return subset of previously obtained results
            delegate.searchResults = [delegate.savedSearchResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@", query]];
            searchStatus = ([delegate.searchResults count]) ? DARemoteSearchOK : DARemoteSearchEmpty;
            
        } else {
            delegate.savedSearchText = nil;
            delegate.savedSearchResults = nil;
            
            int type = (searchPrefix) ? DARemoteSearchPrefix : DARemoteSearchSuffix;
            
            NSString *cachedResponse = [DARemote fetchCachedResultForQuery:query ofType:type error:nil];
            
            if (nil != cachedResponse) {
                // Use cached response
                delegate.searchResults = [DAParser parseAPIResponse:cachedResponse list:YES];
                searchStatus = ([delegate.searchResults count]) ? DARemoteSearchOK : DARemoteSearchEmpty;
                
                if (searchPrefix && [delegate.searchResults count] < 10) {
                    delegate.savedSearchText    = [NSMutableString stringWithString:connection.query];
                    delegate.savedSearchResults = [NSMutableArray arrayWithArray:delegate.searchResults];
                }
                
            } else {
                // Perform new asynchronous request
                connection = [[DARemote alloc] initWithQuery:query ofType:type delegate:self];
                if (nil == connection) {
                    searchStatus = DARemoteSearchNoConnection;
                    delegate.searchResults = nil;
                } else if (!delegate.searchResults) {
                    searchStatus = DARemoteSearchWait;
                    delegate.searchResults = [NSArray arrayWithObjects:nil];
                }
            }
            
            [self reloadSearchResultsTable];
        }
        
    } else {
        searchStatus            = DARemoteSearchOK;
        searching               = NO;
        letUserSelectRow        = NO;
        delegate.searchResults  = nil;
        [self.searchDisplayController.searchResultsTableView clearsContextBeforeDrawing];
    }
}


- (void)reloadSearchResultsTable {
    letUserSelectRow = (DARemoteSearchOK == searchStatus);
    self.searchDisplayController.searchResultsTableView.scrollEnabled = (DARemoteSearchOK == searchStatus);
    [self.searchDisplayController.searchResultsTableView reloadData];
    //[self dropShadowFor:self.searchDisplayController.searchResultsTableView enabled:letUserSelectRow];
}


// InfoTableController
- (void) showInfoTable {
    InfoTableController *infoTable = [[InfoTableController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pesquisa" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [delegate.navController pushViewController:infoTable animated:YES];
    [infoTable release];
    [self.navigationItem.backBarButtonItem release];
}


#pragma mark UITableViewDataSource Methods


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier;
    static NSString *cellNib;
    
    if (DARemoteSearchOK == searchStatus) {
        cellIdentifier  = @"searchCell";
        cellNib         = @"SearchCell";
        
    } else {
        cellIdentifier  = @"errorCell";
        cellNib         = @"SearchErrorCell";
    }
    
    SearchCell *cell = (SearchCell *)[tv dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {        
        // Loop over topLevelObjects in NIB, looking for DefinitionCell
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellNib owner:nil options:nil];
        
        for (id o in topLevelObjects)
        {
            if ([o isKindOfClass:[SearchCell class]])
            {
                cell = (SearchCell *)o;
                break;
            }
        }
    }
    
    if (DARemoteSearchNoConnection == searchStatus) {
        [cell setError:@"Erro de ligação" type:searchStatus];
        
    } else if (DARemoteSearchEmpty == searchStatus) {
        [cell setError:@"Sem resultados" type:searchStatus];

    } else if (DARemoteSearchWait == searchStatus) {
        [cell setError:@"Aguarde" type:searchStatus];
        
    } else if (DARemoteSearchOK == searchStatus) {
        [cell setContentAtRow:indexPath.row using:delegate.searchResults];
    }
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if (delegate.searchResults != nil) {
        return (DARemoteSearchOK == searchStatus) ? [delegate.searchResults count] : 1;
        
    } else {
        return 0;
    }
}


#pragma mark UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (DARemoteSearchOK != searchStatus) {
        return (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
            ? tableView.frame.size.height
            : tableView.frame.size.height + 44;
        
    } else {
        return 44;
    }
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (letUserSelectRow)
        return indexPath;
    else
        return nil;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (nil != connection) {
        // Cancel any pending requests
        connection.cancel;
        [connection release];
        connection = nil;
    }

    NSString *query = [delegate.searchResults objectAtIndex:indexPath.row];
    NSInteger first = [delegate.searchResults indexOfObject:query];
    NSInteger n     = (first > indexPath.row) ? 0 : indexPath.row - first + 1;
    
    DefinitionController *definition = [[DefinitionController alloc] initWithRequest:query atIndex:n];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pesquisa" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [delegate.navController pushViewController:definition animated:YES];
    [definition release];
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationItem.backBarButtonItem release];
}


#pragma mark UISearchBarDelegate Methods


#pragma mark UISearchDisplayDelegate Methods


- (void) searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    tableView.backgroundColor   = searchResultsTable.backgroundColor;
    // tableView.separatorColor    = searchResultsTable.separatorColor;
    // tableView.separatorStyle    = searchResultsView.separatorStyle;
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    searchPrefix = (searchOption == 0);
    [self searchDicionarioAberto:controller.searchBar.text];
    return NO;
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self searchDicionarioAberto:searchString];
    return NO;
}


#pragma mark DARemoteDelegate Methods


- (void)connectionDidFail:(DARemote *)theConnection {
    searchStatus = DARemoteSearchNoConnection;
    [self reloadSearchResultsTable];
}


- (void)connectionDidFinish:(DARemote *)theConnection {
    NSString *response = [[NSString alloc] initWithData:theConnection.receivedData encoding:NSUTF8StringEncoding];
    
    delegate.searchResults = [DAParser parseAPIResponse:response list:YES];
    searchStatus = ([delegate.searchResults count]) ? DARemoteSearchOK : DARemoteSearchEmpty;
    
    if ([delegate.searchResults count]) {
        [DARemote cacheResult:response forQuery:theConnection.query ofType:connection.type error:nil];
    }
    
    [response release];
     
    // Save result set in memory for reuse
    if (searchPrefix && [theConnection.query length] && [delegate.searchResults count] < 10) {
        delegate.savedSearchText    = [NSMutableString stringWithString:connection.query];
        delegate.savedSearchResults = [NSMutableArray arrayWithArray:delegate.searchResults];
    }

    [self reloadSearchResultsTable];
}


@end
