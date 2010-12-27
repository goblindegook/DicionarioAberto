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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pesquisa"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
    
    [delegate.navController pushViewController:definition animated:YES];
    
    [definition release];
    
    [tv deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark UISearchBarDelegate Methods

/*
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)sb {  
    sb.showsCancelButton = NO;
    sb.showsScopeBar = YES;
    return YES;
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)sb {  
    sb.showsCancelButton = NO;
    sb.showsScopeBar = NO;
    return YES;
}
*/

- (void)searchBarTextDidBeginEditing:(UISearchBar *)sb {
    //sb.showsCancelButton = NO;
    sb.showsScopeBar = YES;

    searching = YES;
    letUserSelectRow = YES;
    
    self.searchResultsView.scrollEnabled = NO;
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)sb {
	//sb.showsCancelButton = NO;
    letUserSelectRow = YES;
    sb.showsScopeBar = YES;
}

/*
- (void)searchBarCancelButtonClicked:(UISearchBar *)sb {
}
*/

/*
- (void)searchBarSearchButtonClicked:(UISearchBar *)sb {
    [self.searchResultsView reloadData];
    [sb resignFirstResponder];
}
*/

- (void)searchBar:(UISearchBar *)sb selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    searchPrefix = (selectedScope == 0);
    
    if (searchPrefix)
        delegate.searchResults = [DARemote searchWithPrefix:[sb text] error:nil];
    else
        delegate.searchResults = [DARemote searchWithSuffix:[sb text] error:nil];
    
    [self.searchResultsView reloadData];
}


- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([searchText length] > 0) {
        searching = YES;
        letUserSelectRow = YES;
        self.searchResultsView.scrollEnabled = YES;
        
        BOOL searchSaved = (searchPrefix
                            //&& [delegate.savedSearchResults count]
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
        self.searchResultsView.scrollEnabled = YES;
        delegate.searchResults = nil;
    }

    [self.searchResultsView reloadData];
}


@end
