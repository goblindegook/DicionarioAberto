//
//  InfoController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 04/01/2011.
//

#import "InfoTableController.h"

@implementation InfoTableController

@synthesize infoTableView;
@synthesize infoTableContents;

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
    
    self.infoTableContents = [NSArray arrayWithObjects:
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Sobre o Dicionário Aberto",     @"title", @"page", @"type", @"aberto://page/about", @"uri", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Ficha técnica",                 @"title", @"page", @"type", @"aberto://page/credits", @"uri", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Razão da obra",                 @"title", @"page", @"type", @"aberto://page/intro1", @"uri", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Materiaes da obra",             @"title", @"page", @"type", @"aberto://page/intro2", @"uri", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Processo da obra",              @"title", @"page", @"type", @"aberto://page/intro3", @"uri", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"A orthografia",                 @"title", @"page", @"type", @"aberto://page/intro4", @"uri", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"A pronúncia",                   @"title", @"page", @"type", @"aberto://page/intro5", @"uri", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"A accentuação gráphica",        @"title", @"page", @"type", @"aberto://page/intro6", @"uri", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"A etymologia",                  @"title", @"page", @"type", @"aberto://page/intro7", @"uri", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"A grammática",                  @"title", @"page", @"type", @"aberto://page/intro8", @"uri", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Sinaes e abreviaturas",         @"title", @"page", @"type", @"aberto://page/abbrev", @"uri", nil],
                              nil];
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
    
    NSDictionary *cellInfo = (NSDictionary *)[self.infoTableContents objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellInfo objectForKey:@"title"];
    //cell.detailTextLabel.text = [cellInfo objectForKey:@"uri"];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"%d", [self.infoTableContents count]);
    
    return [self.infoTableContents count];
}


#pragma mark UITableViewDelegate Methods

/*
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
*/


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tv deselectRowAtIndexPath:indexPath animated:YES];
}


@end
