//
//  DefinitionController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "DefinitionController.h"
#import "DADelegate.h"
#import "SuperEntry.h"
#import "Entry.h"
#import "Form.h"
#import "Sense.h"
#import "Usage.h"
#import "Etymology.h"

@implementation DefinitionController

- (id)initWithIndexPath:(NSIndexPath *)indexPath {
    if (self == [super init]) {
        index = indexPath;
    }
    return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    NSString *thisResult = [delegate.searchResults objectAtIndex:index.row];
    
    // TODO: obtain thisResult definition
    
    /* temp */
    Entry *palavra = [[Entry alloc] init];
    palavra.entryId = [[NSMutableString alloc] initWithString:@"palavra"];
    palavra.entryForm = [[Form alloc] init];
    [palavra entryForm].orth = [[NSMutableString alloc] initWithString:@"Palavra"];
    palavra.entryEtymology = [[Etymology alloc] init];
    [palavra entryEtymology].ori = [[NSMutableString alloc] initWithString:@"lat"];
    [palavra entryEtymology].text = [[NSMutableString alloc] initWithString:@"(Do lat. _parabola_)"];
    palavra.entrySense = [[NSMutableArray alloc] init];
    Sense *palavraSense = [[Sense alloc] init];
    palavraSense.ast = 1;
    palavraSense.def = [[NSMutableString alloc] initWithString:@"Som articulado, que tem um sentido ou significação.\nVocábulo; termo.\nDicção ou phrase.\nAffirmação.\nFala, faculdade de exprimir as ideias por meio da voz.\nO discorrer.\nDeclaração.\nPromessa verbal: _não falto, dou-lhe a minha palavra_.\nPermissão de falar: _peço a palavra_."];
    palavraSense.gramGrp = [[NSMutableString alloc] initWithString:@"f."];
    [palavra.entrySense addObject:palavraSense];
    /* temp */
    
    self.title = [palavra entryForm].orth;
    
    NSEnumerator *e = [[palavra entrySense] objectEnumerator];
    id object;
    while (object = [e nextObject]) {
    }
    
    [palavra release];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [request URL];
        if ([[url scheme] isEqualToString:@"definition"]) {
            // TODO: Internal link, don't load URL in Web View
            return NO;
        }
    }
    return YES;
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [index release];
    [definitionView release];
    [super dealloc];
}


@end
