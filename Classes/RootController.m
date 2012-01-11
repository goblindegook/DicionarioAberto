//
//  DicionarioAbertoViewController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import "RootController.h"
#import "Entry.h"

@implementation RootController

@synthesize searchResultsTable;

#pragma mark -
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showInfoTable) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    
    searchResultsTable.hidden   = YES;
    tableHasShadow              = YES;
    searchPrefix                = YES;
    searching                   = NO;
    letUserSelectRow            = YES;
    searchStatus                = DARemoteSearchOK;
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




- (void)dropShadowFor:(UITableView *)tableView {
    // TODO
}


- (void)searchDicionarioAberto:(NSString *)query {
    
    if ([query length] > 0) {
        searching = YES;
        
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObject:query
                                                                             forKey:(searchPrefix) ? @"prefix" : @"suffix"];
        
        // Perform new asynchronous request
        
        [Entry entriesWithURLString:@""
                         parameters:parameters
                            success:^(NSArray *records) {
                                NSLog(@"%@", records);
                                
                                delegate.searchResults = records;
                                searchStatus = ([delegate.searchResults count]) ? DARemoteSearchOK : DARemoteSearchEmpty;        
                                
                                [self reloadSearchResultsTable:self.searchDisplayController.searchResultsTableView];
                                
                            }
                            failure:^(NSError *error) {
                                searchStatus = DARemoteSearchNoConnection;
                                searchStatus = DARemoteSearchUnavailable;
                                delegate.searchResults = [NSArray arrayWithObjects:nil];
                                [self reloadSearchResultsTable:self.searchDisplayController.searchResultsTableView];
                                NSLog(@"%@", error);
                            }
         ];
        
    } else {
        searchStatus            = DARemoteSearchOK;
        searching               = NO;
        letUserSelectRow        = NO;
        delegate.searchResults  = nil;
    }
}


- (void)reloadSearchResultsTable:(UITableView *)tableView {
    letUserSelectRow = (DARemoteSearchOK == searchStatus);
    tableView.scrollEnabled = (DARemoteSearchOK == searchStatus);

    if (tableHasShadow && letUserSelectRow)
        [self dropShadowFor:tableView];
    
    [tableView reloadData];
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


// InfoTableController
- (void) showInfoTable {
    InfoTableController *infoTable = [[InfoTableController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pesquisa" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [delegate.navController pushViewController:infoTable animated:YES];
    //self.navigationItem.backBarButtonItem;
}


#pragma mark -
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

    } else if (DARemoteSearchUnavailable == searchStatus) {
        [cell setError:@"Indisponível" type:searchStatus];
        
    } else if (DARemoteSearchEmpty == searchStatus) {
        [cell setError:@"Sem resultados" type:searchStatus];

    } else if (DARemoteSearchWait == searchStatus) {
        [cell setError:@"Aguarde" type:searchStatus];
        
    } else if (DARemoteSearchOK == searchStatus) {
        [cell setContentAtRow:indexPath.row using:delegate.searchResults];

    } else {
        [cell setError:@"Desconhecido" type:searchStatus];
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


#pragma mark -
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

    NSString *query = [delegate.searchResults objectAtIndex:indexPath.row];
    NSInteger first = [delegate.searchResults indexOfObject:query];
    NSInteger n     = (first > indexPath.row) ? 0 : indexPath.row - first + 1;
    
    DefinitionController *definition = [[DefinitionController alloc] initWithRequest:query atIndex:n];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pesquisa" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [delegate.navController pushViewController:definition animated:YES];
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    //self.navigationItem.backBarButtonItem;
}


#pragma mark -
#pragma mark UISearchDisplayDelegate Methods


- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    tableView.backgroundColor       = searchResultsTable.backgroundColor;
    tableView.separatorStyle        = searchResultsTable.separatorStyle;
    tableView.separatorColor        = searchResultsTable.separatorColor;
    tableView.autoresizesSubviews   = YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    searchPrefix = (searchOption == 0);
    [self searchDicionarioAberto:controller.searchBar.text];
    return NO;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self searchDicionarioAberto:searchString];
    return NO;
}


- (void) searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
}


#pragma mark -
#pragma mark UIKeyboardDidHideNotification Method

- (void)keyboardDidHide:(NSNotification *)notification {
    // Restore inset and prevent table from bouncing back to top when hiding the keyboard:
    if (tableHasShadow) {
        [self.searchDisplayController.searchResultsTableView setContentInset:UIEdgeInsetsMake(-20, 0, -20, 0)];
    }
}

@end
