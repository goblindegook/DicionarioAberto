//
//  DefinitionController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "DefinitionController.h"
#import "DADelegate.h"

#import "TouchXML.h"

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
- (void)loadHTMLEntries:(NSArray *)entries {
    [self loadHTMLEntries:entries n:0];
}

// Generate HTML entry
- (void)loadHTMLEntries:(NSArray *)entries n:(NSInteger)n {
    
    // TODO:
    // Loop over entries
    // Skip irrelevant entries if index provided
    // Replace markup: _italic_, [[link]]
    
    NSMutableString *content = [NSMutableString stringWithString:@""];
    
    [content appendString:@""
     @"<!DOCTYPE html>\n"
     @"<html><head>"
     @"<meta charset=\"UTF-8\">"
     @"<link rel=\"stylesheet\" type=\"text/css\" href=\"DicionarioAberto.css\">"
     @"</head><body>"
    ];
    
    // Loop over definition entries
    for (Entry *entry in entries) {
        // Skip entry:
        if (n && entry.n != n) {
            continue;
        }
        
        [content appendString:@"<h1 class=\"term\">"];
        if (entries.count > 1) {
            [content appendFormat:@"<span class=\"index\">%d</span>", entry.n];
        }
        [content appendString:entry.entryForm.orth];
        if ([entry.entryForm.phon length]) {
            [content appendFormat:@"<span class=\"phon\">, (%@)</span>", entry.entryForm.phon];
        }
        [content appendString:@"</h1>"];

        [content appendString:@"<section class=\"senses\">"];
        
        // Loop over definitions
        for (Sense *sense in entry.entrySense) {
            [content appendString:@"<section class=\"sense\">"];
            
            // Lexical category
            [content appendFormat:@"<div class=\"lex\">%@</div>", sense.gramGrp];
            
            // Definitions
            [content appendString:@"<ol class=\"definitions\">"];
            for (NSString *chunk in [[sense htmlDef] componentsSeparatedByString: @"\n"]) {
                if (chunk.length > 0) {
                    [content appendString:@"<li><span class=\"singledef\">"];
                    if (sense.usg.text.length > 0) {
                        [content appendFormat:@"<span class=\"usage %@\">%@</span> ", sense.usg.type, sense.usg.text];                        
                    }
                    [content appendString:chunk];
                    [content appendString:@"</span></li>"];
                }
            }
            [content appendString:@"</ol>"];
            [content appendString:@"</section>"];
        }
        
        [content appendString:@"</section>"];
        
        // Etymology
        [content appendString:@"<section class=\"etym\">"];
        [content appendString:[entry.entryEtymology html]];
        [content appendString:@"</section>"];
    }

    // TODO: related entries
    if (!n && entries.count > 1) {
        [content appendString:@"<aside class=\"related\">TODO</aside>"];
    }
        
    NSString *footerPath = [[NSBundle mainBundle] pathForResource:@"footer" ofType:@"html" inDirectory:@"HTML"];
    
    [content appendString:[NSString stringWithContentsOfFile:footerPath encoding:NSUTF8StringEncoding error:nil]];
    
    [content appendString:@"</body></html>"];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    [definitionView loadHTMLString:content baseURL:baseURL];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    NSString *thisResult = [delegate.searchResults objectAtIndex:index.row];
    
    self.title = thisResult;
    
    // Obtain definition from DicionarioAberto API
    NSURL *apiURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://dicionario-aberto.net/search-xml/%@", thisResult]];
    NSString *apiResult = [NSString stringWithContentsOfURL:apiURL encoding:NSUTF8StringEncoding error:nil];
    
    // TODO: Escape URL
    // TODO: Check for errors
    // TODO: Cache results up to X items
    
    Entry *entry = [[Entry alloc] initFromXMLString:apiResult error:nil];
    
    NSMutableArray *entries = [[NSMutableArray alloc] initWithObjects:entry, nil];
    
    [self loadHTMLEntries:entries n:entry.n];
    
    [entries release];
    [entry release];
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
