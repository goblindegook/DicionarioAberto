//
//  DicionarioAbertoViewController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import "RootController.h"
#import "DefinitionController.h"
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
    self.title = @"Dicionário Aberto";
    
    searching = NO;
    letUserSelectRow = YES;
    
    //[super viewDidLoad];
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

- (UITableViewCell *)tableView:(UITableView *)srv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [srv dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
    }
    
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *cellEntry = [delegate.searchResults objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cellEntry;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)srv
 numberOfRowsInSection:(NSInteger)section {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    return [delegate.searchResults count];
}

#pragma mark UITableViewDelegate Methods

- (NSIndexPath *)tableView:(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)theSearchBar {  
    searchBar.showsCancelButton = NO;
    return YES;
}


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)theSearchBar {  
    searchBar.showsCancelButton = NO;
    [searchBar sizeToFit];
    return YES;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    searching = YES;
    letUserSelectRow = YES;
    searchBar.showsCancelButton = NO;
    
    self.searchResultsView.scrollEnabled = NO;
}


- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([searchText length] > 0) {
        searching = YES;
        letUserSelectRow = YES;
        self.searchResultsView.scrollEnabled = YES;
        
        // TODO: Prevent API call when searchResults < 10, search only within previously obtained list
        
        delegate.searchResults = [DARemote searchWithPrefix:searchText error:nil];
    } else {
        searching = NO;
        letUserSelectRow = NO;
        self.searchResultsView.scrollEnabled = NO;
        delegate.searchResults = nil;
    }

    [self.searchResultsView reloadData];
}


@end
