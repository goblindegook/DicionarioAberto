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
    
    searching                   = NO;    
    searchPrefix                = YES;
    letUserSelectRow            = YES;
    searchStatus                = DARemoteSearchOK;
    
    //NSDate *cutoff = [[NSDate alloc] initWithTimeIntervalSinceNow:(-3600 * 24 * 2)]; // 2d
    NSDate *cutoff = [[NSDate alloc] initWithTimeIntervalSinceNow:(-300)]; // 5m
    
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
    [searchResultsTable release];
    [tableHeaderView release];
    [tableFooterView release];
    [super dealloc];
}


- (void)dropShadowFor:(UITableView *)tableView enabled:(BOOL)enabled {
    
    if (enabled) {
        UIColor *light = (id)[tableView.backgroundColor colorWithAlphaComponent:0.0].CGColor;
        UIColor *darkH = (id)[UIColor colorWithWhite:0 alpha:0.15].CGColor;
        UIColor *darkF = (id)[UIColor colorWithWhite:0 alpha:0.25].CGColor;
        
        if (tableHeaderView == nil) {
            tableHeaderView = [[OBGradientView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)];
            tableHeaderView.colors = [NSArray arrayWithObjects:(id)light, (id)darkH, nil];
            tableHeaderView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
        }
        
        if (tableFooterView == nil) {
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


// Asynchronous call wrapper method for search text changes
- (void)searchDicionarioAbertoSelector:(NSString *)query {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self searchDicionarioAberto:query];
    [pool drain];
}


- (void)searchDicionarioAberto:(NSString *)query {
    
    if ([query length] > 0) {
        searching = YES;
        
        BOOL searchSaved = (searchPrefix
                            && [delegate.savedSearchText length]
                            && [query hasPrefix:delegate.savedSearchText]
                            );
        
        if (searchSaved && searchPrefix) {
            delegate.searchResults = [delegate.savedSearchResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@", query]];
            
        } else if (searchPrefix) {
            delegate.searchResults = [DARemote search:query type:DARemoteSearchPrefix error:nil];
            
        } else {
            delegate.searchResults = [DARemote search:query type:DARemoteSearchSuffix error:nil];
        }
        
        if (delegate.searchResults == nil) {
            searchStatus = DARemoteSearchErrorConnection;
            
        } else if (![delegate.searchResults count]) {
            searchStatus = DARemoteSearchEmpty;
            
        } else {
            searchStatus = DARemoteSearchOK;
        }
        
        // Save result set in memory for reuse
        if (searchPrefix && !searchSaved && DARemoteSearchErrorConnection != searchStatus) {
            if ([query length] && [delegate.searchResults count] < 10) {
                [self performSelectorOnMainThread:@selector(setSavedSearchResultsOnMainThread:) withObject:[NSArray arrayWithObjects:query, delegate.searchResults, nil] waitUntilDone:YES];
                // delegate.savedSearchText    = [NSMutableString stringWithString:query];
                // delegate.savedSearchResults = [NSMutableArray arrayWithArray:delegate.searchResults];
            }
        }
        
    } else {
        searching               = NO;
        searchStatus            = DARemoteSearchOK;
        delegate.searchResults  = nil;
    }
    
    // Update table view in the main thread because UIKit is not thread-safe
    [self performSelectorOnMainThread:@selector(reloadSearchDataOnMainThread) withObject:nil waitUntilDone:NO];
}


- (void)setSearchResultsOnMainThread:(NSArray *)results {
    assert([NSThread isMainThread]);
    // TODO
}


- (void)setSavedSearchResultsOnMainThread:(NSArray *)results {
    assert([NSThread isMainThread]);
    
    delegate.savedSearchText    = (NSMutableString *)[results objectAtIndex:0];
    delegate.savedSearchResults = (NSMutableArray *)[results objectAtIndex:1];
}


- (void)reloadSearchDataOnMainThread {
    assert([NSThread isMainThread]);
    
    if (searching) {
        [self.searchDisplayController.searchResultsTableView reloadData];
        letUserSelectRow = (DARemoteSearchOK == searchStatus);
        
    } else {
        [self.searchDisplayController.searchResultsTableView clearsContextBeforeDrawing];
        letUserSelectRow = NO;
    }
    
    self.searchDisplayController.searchResultsTableView.scrollEnabled = (DARemoteSearchOK == searchStatus);

    [self dropShadowFor:self.searchDisplayController.searchResultsTableView enabled:(BOOL)[delegate.searchResults count]];
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
    
    if (DARemoteSearchErrorConnection == searchStatus) {
        [cell setError:@"Erro de ligação" type:DASearchConnectionError];
        
    } else if (DARemoteSearchEmpty == searchStatus) {
        [cell setError:@"Sem resultados" type:DASearchNoResults];
        
    } else if (DARemoteSearchOK == searchStatus) {
        [cell setContentAtRow:indexPath.row using:delegate.searchResults];
    }
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return (DARemoteSearchOK == searchStatus) ? [delegate.searchResults count] : 1;
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
    DefinitionController *definition = [[DefinitionController alloc] initWithIndexPath:indexPath];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pesquisa" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [delegate.navController pushViewController:definition animated:YES];
    [definition release];
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationItem.backBarButtonItem release];
}


#pragma mark UISearchBarDelegate


#pragma mark UISearchDisplayDelegate


- (void) searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    tableView.backgroundColor   = searchResultsTable.backgroundColor;
    // tableView.separatorColor    = searchResultsTable.separatorColor;
    // tableView.separatorStyle    = searchResultsView.separatorStyle;
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    searchPrefix = (searchOption == 0);
    
    // Cancel previous asynchronous request:
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchDicionarioAbertoSelector:) object:nil];

    // Search asynchronously, reload results table later:
    [self performSelectorInBackground:@selector(searchDicionarioAbertoSelector:) withObject:controller.searchBar.text];
    
    return NO;
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Cancel previous asynchronous request:
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchDicionarioAbertoSelector:) object:nil];

    // Search asynchronously, reload results table later:
    [self performSelectorInBackground:@selector(searchDicionarioAbertoSelector:) withObject:searchString];
    
    return NO;
}


@end
