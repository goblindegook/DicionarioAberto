//
//  DicionarioAbertoViewController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import "RootController.h"
#import "DefinitionController.h"
#import "SearchCell.h"
#import "DADelegate.h"
#import "DARemote.h"
#import "Entry.h"
#import "Form.h"
#import "EntrySense.h"
#import "EntrySenseUsage.h"
#import "EntryEtymology.h"

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
    
    self.title = @"Dicionário Aberto";
    
    searchResultsTable.hidden   = YES;
    
    searchPrefix                = YES;
    searching                   = NO;
    letUserSelectRow            = YES;
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

- (void) dropShadowFor:(UITableView *)tableView {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([delegate.searchResults count]) {
        UIColor *light = (id)[tableView.backgroundColor colorWithAlphaComponent:0.0].CGColor;
        UIColor *darkH = (id)[UIColor colorWithWhite:0 alpha:0.15].CGColor;
        UIColor *darkF = (id)[UIColor colorWithWhite:0 alpha:0.25].CGColor;
        
        if (tableHeaderView == nil) {
            tableHeaderView = [[OBGradientView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
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
        
        [tableView setContentInset:UIEdgeInsetsMake(-10, 0, -20, 0)];
        
    } else {
        tableView.tableHeaderView = nil;
        tableView.tableFooterView = nil;
        
        [tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}


- (void) searchDicionarioAberto:(NSString *)query {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([query length] > 0) {
        searching = YES;
        letUserSelectRow = YES;
        
        BOOL searchSaved = (searchPrefix
                            && [delegate.savedSearchText length]
                            && [query hasPrefix:delegate.savedSearchText]
                            );
        
        if (searchSaved) {
            if (searchPrefix) {
                delegate.searchResults = [delegate.savedSearchResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@", query]];
            } else {
                delegate.searchResults = [delegate.savedSearchResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF ENDSWITH[c] %@", query]];
            }
        } else {
            if (searchPrefix) {
                delegate.searchResults = [DARemote search:query type:DARemoteSearchPrefix error:nil];
            } else {
                delegate.searchResults = [DARemote search:query type:DARemoteSearchSuffix error:nil];
            }
        }
        
        if (searchPrefix && !searchSaved) {
            if ([query length] && [delegate.searchResults count] < 10) {
                delegate.savedSearchText = [NSMutableString stringWithString:query];
                delegate.savedSearchResults = [NSMutableArray arrayWithArray:delegate.searchResults];
            }
        }
        
        [self.searchDisplayController.searchResultsTableView reloadData];
        
    } else {
        searching = NO;
        letUserSelectRow = NO;
        delegate.searchResults = nil;
        
        [self.searchDisplayController.searchResultsTableView clearsContextBeforeDrawing];
    }
    
    [self dropShadowFor:self.searchDisplayController.searchResultsTableView];
}


#pragma mark UITableViewDataSource Methods


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"searchCell";
    
    // UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
    SearchCell *cell = (SearchCell *)[tv dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        // cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
        
        // Loop over topLevelObjects in NIB, looking for DefinitionCell
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:nil options:nil];
        
        for (id o in topLevelObjects)
        {
            if ([o isKindOfClass:[SearchCell class]])
            {
                cell = (SearchCell *)o;
                break;
            }
        }
    }
    
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *cellEntry = [delegate.searchResults objectAtIndex:indexPath.row];
    
    cell.definitionOrth.text = cellEntry;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    return [delegate.searchResults count];
}

#pragma mark UITableViewDelegate Methods

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (letUserSelectRow)
        return indexPath;
    else
        return nil;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    DefinitionController *definition = [[DefinitionController alloc] initWithIndexPath:indexPath];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pesquisa" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [delegate.navController pushViewController:definition animated:YES];
    
    [definition release];
    
    [tv deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark UISearchBarDelegate



#pragma mark UISearchDisplayDelegate

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
}


- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
}


- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
}


- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
}


- (void) searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
}


- (void) searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
}


- (void) searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    tableView.backgroundColor   = searchResultsTable.backgroundColor;
    tableView.separatorColor    = searchResultsTable.separatorColor;
    //tableView.separatorStyle    = searchResultsView.separatorStyle;
}


- (void) searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    searchPrefix = (searchOption == 0);
    // Search asynchronously, reload results table later:
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    [delegate performSelectorInBackground:@selector(searchDicionarioAberto:) withObject:controller.searchBar.text];
    return NO;
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Search asynchronously, reload results table later:
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    [delegate performSelectorInBackground:@selector(searchDicionarioAberto:) withObject:searchString];
    return NO;
}


@end
