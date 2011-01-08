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
    
    self.infoTableContents
        = [NSArray arrayWithObjects:
           
           [NSDictionary dictionaryWithObjectsAndKeys:
            @"Dicionário Aberto", @"section",
            [NSArray arrayWithObjects:
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Sobre o Dicionário",            @"title", @"page", @"type", @"aberto://static/about.html", @"uri", nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Informação legal",              @"title", @"page", @"type", @"aberto://static/legal.html", @"uri", nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Ficha técnica",                 @"title", @"page", @"type", @"aberto://static/credits.html", @"uri", nil],
             nil], @"rows",
            nil],
           
           [NSDictionary dictionaryWithObjectsAndKeys:
            @"Novo Diccionário de 1913", @"section",
            [NSArray arrayWithObjects:
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Introdução",                    @"title", @"page", @"type", @"aberto://static/intro0.html", @"uri", nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"I. Razão da obra",              @"title", @"page", @"type", @"aberto://static/intro1.html", @"uri", nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"II. Materiaes da obra",         @"title", @"page", @"type", @"aberto://static/intro2.html", @"uri", nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"III. Processo da obra",         @"title", @"page", @"type", @"aberto://static/intro3.html", @"uri", nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"IV. A orthografia",             @"title", @"page", @"type", @"aberto://static/intro4.html", @"uri", nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"V. A pronúncia",                @"title", @"page", @"type", @"aberto://static/intro5.html", @"uri", nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"VI. A accentuação gráphica",    @"title", @"page", @"type", @"aberto://static/intro6.html", @"uri", nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"VII. A etymologia",             @"title", @"page", @"type", @"aberto://static/intro7.html", @"uri", nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"VIII. A grammática",            @"title", @"page", @"type", @"aberto://static/intro8.html", @"uri", nil],
             [NSDictionary dictionaryWithObjectsAndKeys:
              @"Sinaes e abreviaturas",         @"title", @"page", @"type", @"aberto://static/abbrev.html", @"uri", nil],
             nil], @"rows",
            nil],
           
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
    
    NSDictionary *sectionDictionary = [self.infoTableContents objectAtIndex:indexPath.section];
    NSDictionary *rowDictionary = [[sectionDictionary objectForKey:@"rows"] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [rowDictionary objectForKey:@"title"];
    //cell.detailTextLabel.text = [rowDictionary objectForKey:@"uri"];
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return [self.infoTableContents count];
}


- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionDictionary = [self.infoTableContents objectAtIndex:section];
    return [[sectionDictionary objectForKey:@"rows"] count];
}


- (NSString *)tableView:(UITableView *)tv titleForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionDictionary = [self.infoTableContents objectAtIndex:section];
    return [sectionDictionary objectForKey:@"section"];
}


#pragma mark UITableViewDelegate Methods

/*
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
*/


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionDictionary = [self.infoTableContents objectAtIndex:indexPath.section];
    NSDictionary *rowDictionary = [[sectionDictionary objectForKey:@"rows"] objectAtIndex:indexPath.row];
    
    NSLog(@"Selected (%d, %d)", indexPath.section, indexPath.row);
    
    InfoPageController *infoPage = [[InfoPageController alloc] initWithURI:[NSURL URLWithString:[rowDictionary objectForKey:@"uri"]] title:[rowDictionary objectForKey:@"title"]];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [delegate.navController pushViewController:infoPage animated:YES];
    
    [infoPage release];
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationItem.backBarButtonItem release];
}


@end
