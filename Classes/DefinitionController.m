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
    
    NSString *entryOrth = nil;
    
    NSMutableString *content = [NSMutableString stringWithString:@""
     "<!DOCTYPE html>\n"
     "<html><head>"
     "<title></title>"
     "<meta charset=\"UTF-8\">"
     "<link rel=\"stylesheet\" type=\"text/css\" href=\"DicionarioAberto.css\">"
     "</head><body>"
    ];
    
    NSMutableString *homonyms = [NSMutableString stringWithString:@""];
    
    // Homonyms
    if (n && entries.count > 1) {
        [homonyms appendString:@"<aside class=\"homonyms\"><h2>Homónimos</h2><div class=\"entries\"><ol>"];
        for (Entry *entry in entries) {
            
            if (entry.n == n) {
                [homonyms appendString:@"<li class=\"term self\">"];
            } else {
                [homonyms appendString:@"<li class=\"term\">"];                
            }
            
            [homonyms appendFormat:@"<a href=\"aberto://define:%d/%@\" class=\"entry\">%@</a>",
             entry.n,
             [[NSRegularExpression regularExpressionWithPattern:@"^([^:]+):\\d+" options:0 error:nil] stringByReplacingMatchesInString:entry.entryId options:0 range:NSMakeRange(0, [entry.entryId length]) withTemplate:@"$1"],
             entry.entryForm.orth];
            
            [homonyms appendString:@"</li>"];
        }
        [homonyms appendString:@"</ol></div></aside>"];
    }
    
    // Loop over definition entries
    for (Entry *entry in entries) {
        // Skip entry:
        if (n && entry.n && entry.n != n) {
            continue;
        }
        
        if (entryOrth == nil) {
            entryOrth = [DAMarkup markupToHTML:entry.entryForm.orth];
        }
        
        [content appendString:@"<h1 class=\"term\">"];
        if (entries.count > 1) {
            [content appendFormat:@"<span class=\"index\">%d</span>", entry.n];
        }
        [content appendString:entryOrth];
        if ([entry.entryForm.phon length]) {
            [content appendFormat:@"<span class=\"phon\">, (%@)</span>", entry.entryForm.phon];
        }
        [content appendString:@"</h1>"];
        
        [content appendString:homonyms];
        
        [content appendString:@"<section class=\"senses\">"];
        [content appendString:@"<section class=\"sense\">"];
        [content appendString:@"<ol class=\"definitions\">"];
        
        // Loop over definitions
        for (EntrySense *sense in entry.entrySense) {
            
            // Lexical category
            if (sense.gramGrp) {
                [content appendFormat:@"<div class=\"lex\">%@</div>", sense.gramGrp];
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
    
    if (entryOrth) {
        NSString *footerPath = [[NSBundle mainBundle] pathForResource:@"footer" ofType:@"html" inDirectory:@"HTML"];
        NSString *footer = [NSString stringWithContentsOfFile:footerPath encoding:NSUTF8StringEncoding error:nil];
        [content appendString:[[NSRegularExpression regularExpressionWithPattern:@"%ENTRY%" options:0 error:nil] stringByReplacingMatchesInString:footer options:0 range:NSMakeRange(0, [footer length]) withTemplate:entryOrth]];
    }
        
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
    [super viewDidLoad];
    
    delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showInfoTable) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
    
    definitionView.delegate = self;
    
    NSString *result    = [delegate.searchResults objectAtIndex:index.row];
    NSInteger lr        = [delegate.searchResults indexOfObject:result];
    NSInteger n         = 0;
    
    if (lr <= index.row)
        n = index.row - lr + 1;
    
    [self loadEntry:result n:n];
    
    //[entries release];
}


- (void) showInfoTable {
    InfoTableController *infoTable = [[InfoTableController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Definição" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [delegate.navController pushViewController:infoTable animated:YES];
    [infoTable release];
    [self.navigationItem.backBarButtonItem release];
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
            
            if ([[url host] isEqualToString:@"define"]) {
                // Definition links (aberto://define:*/*)
                NSLog(@"Requested %@:%d", [url lastPathComponent], [[url port] integerValue]);
                NSString *entry = [url lastPathComponent];
                NSInteger n = [[url port] integerValue];
                [self loadEntry:entry n:n];
            }
            
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
