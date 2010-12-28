//
//  DicionarioAbertoViewController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import "RootController.h"
#import "DefinitionController.h"
#import "DefinitionCell.h"
#import "DADelegate.h"
#import "DARemote.h"
#import "Entry.h"
#import "Form.h"
#import "Sense.h"
#import "Usage.h"
#import "Etymology.h"

@implementation RootController

@synthesize searchResultsView;

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
    
    searchPrefix = YES;
    searching = NO;
    letUserSelectRow = YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
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
    [searchResultsView release];
    [super dealloc];
}


- (void) changeScopeDicionarioAberto:(NSInteger)selectedScope {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    searchPrefix = (selectedScope == 0);
    
    if (searchPrefix)
        delegate.searchResults = [DARemote searchWithPrefix:self.searchDisplayController.searchBar.text error:nil];
    else
        delegate.searchResults = [DARemote searchWithSuffix:self.searchDisplayController.searchBar.text error:nil];
    
    [self.searchDisplayController.searchResultsTableView reloadData];
    //[self.searchResultsView reloadData];
}


- (void) searchDicionarioAberto:(NSString *)searchText {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([searchText length] > 0) {
        searching = YES;
        letUserSelectRow = YES;
        
        BOOL searchSaved = (searchPrefix
                            && [delegate.savedSearchText length]
                            && [searchText hasPrefix:delegate.savedSearchText]
                            );
        
        if (searchSaved) {
            if (searchPrefix) {
                delegate.searchResults = [delegate.savedSearchResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH[c] %@", searchText]];
            } else {
                delegate.searchResults = [delegate.savedSearchResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF ENDSWITH[c] %@", searchText]];
            }
        } else {
            if (searchPrefix) {
                delegate.searchResults = [DARemote searchWithPrefix:searchText error:nil];
            } else {
                delegate.searchResults = [DARemote searchWithSuffix:searchText error:nil];
            }
        }
        
        if (!searchSaved) {
            if ([searchText length] && [delegate.searchResults count] < 10) {
                delegate.savedSearchText = [NSMutableString stringWithString:searchText];
                delegate.savedSearchResults = [NSMutableArray arrayWithArray:delegate.searchResults];
            }
        }
        
    } else {
        searching = NO;
        letUserSelectRow = NO;
        delegate.searchResults = nil;
    }
    
    [self.searchDisplayController.searchResultsTableView reloadData];
    //[self.searchResultsView reloadData];
}


#pragma mark UITableViewDataSource Methods


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"definitionCell";
    
    // UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
    DefinitionCell *cell = (DefinitionCell *)[tv dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        // cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
        
        // Loop over topLevelObjects in NIB, looking for DefinitionCell
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DefinitionCell" owner:nil options:nil];
        
        for (id o in topLevelObjects)
        {
            if ([o isKindOfClass:[DefinitionCell class]])
            {
                cell = (DefinitionCell *)o;
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


- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
}


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
    tableView.backgroundColor   = self.searchResultsView.backgroundColor;
    tableView.separatorColor    = self.searchResultsView.separatorColor;
    tableView.separatorStyle    = self.searchResultsView.separatorStyle;
    //tableView.separatorColor    = [UIColor colorWithRed:0.65 green:0.65 blue:0.5 alpha:1];
}


- (void) searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Search asynchronously, reload results table later:
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    [delegate performSelectorInBackground:@selector(changeScopeDicionarioAberto:) withObject:[NSNumber numberWithInteger:searchOption]];
    return NO;
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Search asynchronously, reload results table later:
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    [delegate performSelectorInBackground:@selector(searchDicionarioAberto:) withObject:searchString];
    return NO;
}


@end
