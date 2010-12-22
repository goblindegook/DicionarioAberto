//
//  DefinitionController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "DefinitionController.h"
#import "DADelegate.h"
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


- (void)viewWillAppear:(BOOL)animated {
    // TOOD: Show this while view is constructed
}

// Generate HTML to load for the UIWebView
- (void)loadHTMLDefinition:(NSArray *)entries {
    
    // TODO:
    // Get template resources
    // Loop over entries
    // Skip irrelevant entries if index provided
    // Loop over senses
    // Loop over definition chunks
    // Fill out and replace variables in templates
    // Replace markup: _italic_, [[link]]
    // Output
    
    NSMutableString *content = [[NSMutableString alloc] initWithString:@""];
    
    [content appendString:@"<html><head></head><body>"];
    
    // Loop over definition entries
    NSEnumerator *ee = [entries objectEnumerator];
    Entry *entry;
    while (entry = [ee nextObject]) {
        
        [content appendString:@"<h1 class=\"term\">"];
        [content appendString:[entry entryForm].orth];
        if (entries.count > 1) {
            [content appendFormat:@"<span class=\"n\">%d</string>", [entry n]];
        }
        [content appendString:@"</h1>"];
        
        // Loop over definitions
        NSEnumerator *se = [entry.entrySense objectEnumerator];
        Sense *sense;
        while (sense = [se nextObject]) {
            
            // Lexical category
            [content appendFormat:@"<div class=\"lex\">%@</div>", sense.gramGrp];
            
            // Definitions
            [content appendString:@"<ol class=\"def\">"];
            NSArray *chunks = [sense.def componentsSeparatedByString: @"\n"];
            NSEnumerator *ce = [chunks objectEnumerator];
            NSString *chunk;
            while (chunk = [ce nextObject]) {
                if (chunk.length > 0) {
                    [content appendString:@"<li>"];
                    if (sense.usg.text.length > 0) {
                        [content appendFormat:@"<span class=\"usage\">%@</span> ", sense.usg.text];                        
                    }
                    [content appendString:chunk];
                    [content appendString:@"</li>"];
                }
            }
            [content appendString:@"</ol>"];
        }
        
        // Etymology
        [content appendString:@"<div class=\"etym\">"];
        [content appendString:[entry entryEtymology].text];
        [content appendString:@"</div>"];
    }
    
    [content appendString:@"</body></head>"];
    
    // NSString *entryTemplatePath = [[NSBundle mainBundle] pathForResource:@"Templates/Entry" ofType:@"html"];
    // NSString *content = [[NSString alloc] initWithContentsOfFile:entryTemplatePath];
    
    [definitionView loadHTMLString:content baseURL:nil];
    
    [content release];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    NSString *thisResult = [delegate.searchResults objectAtIndex:index.row];
    
    self.title = thisResult;
    
    // TODO: Obtain definition data for "thisResult"
    
    // NB: API call may return a single entry or a list of homographs in an array of entries
    
    /* BEGIN temp */
    Entry *palavra = [[Entry alloc] init];
    palavra.n = 1;
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
    /* END temp */
    
    NSMutableArray *entries = [[NSMutableArray alloc] initWithObjects:palavra, nil];
    
    [self loadHTMLDefinition:entries];
    
    [entries release];
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
