//
//  InfoController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 04/01/2011.
//

#import "InfoTableController.h"

@implementation InfoTableController

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
    
    infoTableContents = [(NSArray *)[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DAInfoTableContents" ofType:@"plist"]] objectForKey:@"InfoTableContents"] retain];
    
    // Navigation bar shadow
    navBarShadow.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:0.6].CGColor, (id)[UIColor colorWithWhite:0 alpha:0].CGColor, nil];
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
    [navBarShadow release];
    [infoTableView release];
    [infoTableContents release];
    [super dealloc];
}


#pragma mark UITableViewDataSource Methods


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"infoCell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
    }
    
    NSDictionary *sectionDictionary = [infoTableContents objectAtIndex:indexPath.section];
    NSDictionary *rowDictionary = [[sectionDictionary objectForKey:@"Rows"] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [rowDictionary objectForKey:@"Title"];
    //cell.detailTextLabel.text = [rowDictionary objectForKey:@"uri"];
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return [infoTableContents count];
}


- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionDictionary = [infoTableContents objectAtIndex:section];
    return [[sectionDictionary objectForKey:@"Rows"] count];
}


- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionDictionary = [infoTableContents objectAtIndex:section];
    return [sectionDictionary objectForKey:@"Section"];
}


#pragma mark UITableViewDelegate Methods

/*
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
*/


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionDictionary = [infoTableContents objectAtIndex:indexPath.section];
    NSDictionary *rowDictionary = [[sectionDictionary objectForKey:@"Rows"] objectAtIndex:indexPath.row];
    
    // NSLog(@"Selected (%d, %d)", indexPath.section, indexPath.row);
    
    InfoPageController *infoPage = [[InfoPageController alloc] initWithURI:[NSURL URLWithString:[rowDictionary objectForKey:@"URI"]] title:[rowDictionary objectForKey:@"Title"]];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Índice" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [delegate.navController pushViewController:infoPage animated:YES];
    
    [infoPage release];
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationItem.backBarButtonItem release];
}


@end
