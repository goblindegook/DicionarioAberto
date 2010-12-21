//
//  DicionarioAbertoViewController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//  Copyright log - Open Source Consulting 2010. All rights reserved.
//

#import "RootController.h"
#import "DADelegate.h"
#import "SuperEntry.h"
#import "Entry.h"
#import "Form.h"
#import "Sense.h"
#import "Usage.h"
#import "Etym.h"

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
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    searchResults = delegate.searchResults;
    //[super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
    [searchResults release];
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
    
    Entry *cellEntry = [searchResults objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cellEntry.entryId;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)srv
 numberOfRowsInSection:(NSInteger)section {
    return [searchResults count];
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Go to word definition
    
    Entry *entry = [searchResults objectAtIndex:indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:[[entry entryForm] orth]
                          message:[[[entry entrySense] objectAtIndex:0] def]
                          delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil];
    [alert show];
    [alert autorelease];
    
    [tv deselectRowAtIndexPath:indexPath animated:YES];
}

@end
