//
//  DefinitionController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//  Copyright 2010 log - Open Source Consulting. All rights reserved.
//

#import "DefinitionController.h"

@implementation DefinitionController

@synthesize requestedEntry;
@synthesize requestedN;

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
    // TODO: Show this while view is constructed
}


// Additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showInfoTable) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
    
    definitionView.delegate = self;
    
    NSString *query = [delegate.searchResults objectAtIndex:index.row];
    NSInteger first = [delegate.searchResults indexOfObject:query];
    
    self.requestedEntry = query;
    self.requestedN     = (first > index.row) ? 0 : index.row - first + 1;
    
    [self searchDicionarioAberto:query];
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)urlRequest navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [urlRequest URL];
        
        if ([[url scheme] isEqualToString:@"aberto"]) {
            // Internal links
            
            if ([[url host] isEqualToString:@"define"]) {
                // Definition links (aberto://define:*/*)
                self.requestedEntry = [url lastPathComponent];
                self.requestedN     = [[url port] integerValue];
                NSLog(@"Requested %@:%d", self.requestedEntry, self.requestedN);
                [self searchDicionarioAberto:self.requestedEntry];
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
    [requestedEntry release];
    [definitionView release];
    [super dealloc];
}


// Generate HTML entry
- (NSString *)htmlEntryFrom:(NSArray *)entries atIndex:(int)n {
    
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
            entryOrth = [DAParser markupToHTML:entry.entryForm.orth];
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
            for (NSString *chunk in [[DAParser markupToHTML:sense.def] componentsSeparatedByString: @"\n"]) {
                
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
            [content appendString:[DAParser markupToHTML:entry.entryEtymology.text]];
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


- (void)searchDicionarioAberto:(NSString *)query {
    // Obtain definition from DicionarioAberto API    
    NSString *cachedResponse = [DARemote fetchCachedResultForQuery:query ofType:DARemoteGetEntry error:nil];
    
    if (nil != cachedResponse) {
        // Use cached response
        NSArray *entries = [DAParser parseAPIResponse:cachedResponse list:NO];
        [self loadEntryFrom:entries atIndex:self.requestedN];
        
    } else {
        // Perform new asynchronous request
        DARemote *connection = [[DARemote alloc] initWithQuery:query ofType:DARemoteGetEntry delegate:self];
        if (nil == connection) {
            // Connection error
            [self loadNoConnection:query];
        }
        [connection release];
    }    
}


- (void)loadNoConnection:(NSString *)query {
    // TODO: Load error HTML file
    self.title = @"Erro de ligação";
    NSString *html = @"CONNECTION ERROR";
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [definitionView loadHTMLString:html baseURL:baseURL];
}


- (void)loadEntryFrom:(NSArray *)entries atIndex:(int)n {
    self.title = self.requestedEntry;
    NSString *html = [self htmlEntryFrom:entries atIndex:self.requestedN];
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [definitionView loadHTMLString:html baseURL:baseURL];
}


- (void) showInfoTable {
    InfoTableController *infoTable = [[InfoTableController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.title style:UIBarButtonItemStyleBordered target:nil action:nil];
    [delegate.navController pushViewController:infoTable animated:YES];
    [infoTable release];
    [self.navigationItem.backBarButtonItem release];
}


#pragma mark DARemoteDelegate Methods


- (void)connectionDidFail:(DARemote *)connection {
    // Error
}


- (void)connectionDidFinish:(DARemote *)connection {
    NSString *response = [[NSString alloc] initWithData:connection.receivedData encoding:NSUTF8StringEncoding];

    NSArray *entries = [DAParser parseAPIResponse:response list:NO];
    if ([entries count]) {
        [DARemote cacheResult:response forQuery:connection.query ofType:connection.type error:nil];
    }
    [response release];
    
    [self loadEntryFrom:entries atIndex:self.requestedN];
}

@end
