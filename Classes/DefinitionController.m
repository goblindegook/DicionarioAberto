//
//  DefinitionController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "DefinitionController.h"

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
- (NSString *)htmlEntries:(NSArray *)entries {
    return [self htmlEntries:entries n:0];
}

// Generate HTML entry
- (NSString *)htmlEntries:(NSArray *)entries n:(NSInteger)n {
    
    NSMutableString *content = [NSMutableString stringWithString:@""
     "<!DOCTYPE html>\n"
     "<html><head>"
     "<title></title>"
     "<meta charset=\"UTF-8\">"
     "<link rel=\"stylesheet\" type=\"text/css\" href=\"DicionarioAberto.css\">"
     "</head><body>"
    ];
    
    // Loop over definition entries
    for (Entry *entry in entries) {
        // Skip entry:
        if (n && entry.n && entry.n != n) {
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
        [content appendString:@"<section class=\"sense\">"];
        [content appendString:@"<ol class=\"definitions\">"];
        
        // Loop over definitions
        for (EntrySense *sense in entry.entrySense) {
            
            // Lexical category
            if (sense.gramGrp) {
                //[content appendString:@"</ol>"];
                //[content appendString:@"</section>"];
                //[content appendString:@"<section class=\"sense\">"];
                [content appendFormat:@"<div class=\"lex\">%@</div>", sense.gramGrp];
                //[content appendString:@"<ol class=\"definitions\">"];
            }
            
            BOOL firstDef = YES;
            
            // Definitions
            for (NSString *chunk in [[DAMarkup markupToHTML:sense.def] componentsSeparatedByString: @"\n"]) {
                
                if (chunk.length > 0) {
                    [content appendString:@"<li><span class=\"singledef\">"];
                    if (firstDef && sense.usg.text.length > 0) {
                        [content appendFormat:@"<span class=\"usage %@\">%@</span> ", sense.usg.type, sense.usg.text];
                        firstDef = NO;
                    }
                    [content appendString:chunk];
                    [content appendString:@"</span></li>"];
                }
            }
        }
        
        [content appendString:@"</ol>"];
        [content appendString:@"</section>"];
        
        // Etymology
        if (entry.entryEtymology.text) {
            [content appendString:@"<section class=\"etym\">"];
            [content appendString:[DAMarkup markupToHTML:entry.entryEtymology.text]];
            [content appendString:@"</section>"];
        }
        
        [content appendString:@"</section>"];
    }

    // Homonyms
    if (n && entries.count > 1) {
        [content appendString:@"<aside class=\"homonyms\"><h2>Homónimos</h2><ol class=\"entries\">"];
        for (Entry *entry in entries) {
            if (entry.n != n) {
                [content appendFormat:
                 @"<li class=\"term\"><a href=\"aberto://define:%d/%@\" class=\"index\">%d</a></li>",
                 entry.n,
                 [[NSRegularExpression regularExpressionWithPattern:@"^([^:]+):\\d+" options:0 error:nil] stringByReplacingMatchesInString:entry.entryId options:0 range:NSMakeRange(0, [entry.entryId length]) withTemplate:@"$1"],
                 entry.n];
            }
        }
        [content appendString:@"</ol></aside>"];
    }
        
    NSString *footerPath = [[NSBundle mainBundle] pathForResource:@"footer" ofType:@"html" inDirectory:@"HTML"];
    
    [content appendString:[NSString stringWithContentsOfFile:footerPath encoding:NSUTF8StringEncoding error:nil]];
    
    [content appendString:@"</body></html>"];
    
    return content;
}


- (void)loadEntry:(NSString *)entry n:(NSInteger)n {
    
    // Obtain definition from DicionarioAberto API    
    NSArray *entries = [DARemote getEntries:entry error:nil];
    
    self.title = entry;
    
    NSString *html = [self htmlEntries:entries n:n];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    [definitionView loadHTMLString:html baseURL:baseURL];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    managedObjectContext = [delegate managedObjectContext];
    
    definitionView.delegate = self;
    
    NSString *result    = [delegate.searchResults objectAtIndex:index.row];
    NSInteger lr        = [delegate.searchResults indexOfObject:result];
    NSInteger n         = 0;
    
    if (lr <= index.row)
        n = index.row - lr + 1;
    
    [self loadEntry:result n:n];
    
    //[entries release];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [request URL];
        
        if ([[url scheme] isEqualToString:@"aberto"]) {
            // Internal links
            NSLog(@"Requested %@:%d", [url lastPathComponent], [[url port] integerValue]);
            NSString *entry = [url lastPathComponent];
            NSInteger n = [[url port] integerValue];
            [self loadEntry:entry n:n];
            return NO;
            
        } else {
            [[UIApplication sharedApplication] openURL:url];
            return NO;
        }
    }
    return YES;
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
