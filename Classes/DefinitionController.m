//
//  DefinitionController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "DefinitionController.h"

@implementation DefinitionController

#pragma mark Instance Methods

- (id)initWithRequest:(NSString *)entry atIndex:(int)n {
    if (self == [super init]) {
        requestResults = nil;
        requestEntry = [entry copy];
        requestN = n;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
}


// Additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Navigation bar
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showInfoTable) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
    
    // Activity indicator
    activityIndicator.layer.cornerRadius = 8.0f;
    
    // Swipe gestures
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.delegate = self;
    [container addGestureRecognizer:swipeRight];
    
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.delegate = self;
    [container addGestureRecognizer:swipeLeft];

    swipeDoesNothing = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDoesNothingAction)];
    swipeDoesNothing.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    swipeDoesNothing.delegate = self;
    [container addGestureRecognizer:swipeDoesNothing];
    
    // Navigation bar shadow
    navBarShadow.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:0.6].CGColor, (id)[UIColor colorWithWhite:0 alpha:0].CGColor, nil];
    
    definitionView1.delegate = self;
    definitionView2.delegate = self;
    
    pager.numberOfPages = 1;
    transitioning = NO;
    touchRequest = NO;
    
    [self searchDicionarioAberto:requestEntry];
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
    [swipeLeft release];
    [swipeRight release];
    [swipeDoesNothing release];
    [pager release];
    [activityIndicator release];
    [definitionView1 release];
    [definitionView2 release];
    [container release];
    [touchRequestPreviousEntry release];
    [requestEntry release];
    [requestResults release];
    [super dealloc];
}


// Generate HTML entry
- (NSString *)htmlEntryFrom:(NSArray *)entries atIndex:(int)n {
    
    NSString *entryOrth = nil;
    
    NSMutableString *content = [NSMutableString stringWithString:@""];
    
    // Header
    NSString *headerPath = [[NSBundle mainBundle] pathForResource:@"_def_header" ofType:@"html" inDirectory:@"HTML"];
    [content appendString:[NSString stringWithContentsOfFile:headerPath encoding:NSUTF8StringEncoding error:nil]];
    
    // Loop over definition entries
    for (Entry *entry in entries) {
        // Skip entry:
        if (n && entry.n && entry.n != n) {
            continue;
        }
        
        if (entryOrth == nil) {
            entryOrth = [entry.entryForm.orth lowercaseString];
            entryOrth = [DAParser markupToText:entryOrth];
            self.title = entryOrth;
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
    
    // Footer
    NSString *footerPath = [[NSBundle mainBundle] pathForResource:@"_def_footer" ofType:@"html" inDirectory:@"HTML"];
    NSMutableString *footer = [NSMutableString stringWithContentsOfFile:footerPath encoding:NSUTF8StringEncoding error:nil];
    
    footer = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"%ENTRY%" options:0 error:nil] stringByReplacingMatchesInString:footer options:0 range:NSMakeRange(0, [footer length]) withTemplate:entryOrth];

    footer = (NSMutableString *)[[NSRegularExpression regularExpressionWithPattern:@"%FOOTER_CLASS%" options:0 error:nil] stringByReplacingMatchesInString:footer options:0 range:NSMakeRange(0, [footer length]) withTemplate:(n && [entries count] > 1) ? @"pager" : @""];
    
    [content appendString:footer];
              
    return content;
}


- (void)searchDicionarioAberto:(NSString *)query {
    // Obtain definition from DicionarioAberto API    
    NSString *cachedResponse = [DARemote fetchCachedResultForQuery:query ofType:DARemoteGetEntry error:nil];
    
    requestResults = nil;
    
    if (nil != cachedResponse) {
        // Use cached response
        requestResults = [[DAParser parseAPIResponse:cachedResponse list:NO] copy];
        if (touchRequest) {
            [self performTransitionTo:requestResults atIndex:requestN];
        } else {
            [self loadEntry:definitionView1 withArray:requestResults atIndex:requestN];
        }
        
    } else {
        // Perform new asynchronous request
        DARemote *connection = [[DARemote alloc] initWithQuery:query ofType:DARemoteGetEntry delegate:self];
        if (nil == connection) {
            touchRequest = NO;
            // Connection error
            [self loadNoConnection:definitionView1 withString:query];
        } else {
            activityIndicator.hidden = NO;
        }

        [connection release];
    }
}


- (void)loadNoConnection:(UIWebView *)wv withString:(NSString *)query {
    self.title = @"Erro de ligação";
    activityIndicator.hidden = YES;
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"error_connection" ofType:@"html" inDirectory:@"HTML"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [definitionView1 loadHTMLString:html baseURL:baseURL];
}


- (void)loadEntry:(UIWebView *)wv withArray:(NSArray *)entries atIndex:(int)n {
    activityIndicator.hidden = YES;
    
    NSString *html;
    if (entries != nil && [entries count]) {
        self.title = requestEntry;
        html = [self htmlEntryFrom:entries atIndex:n];
    } else {
        self.title = @"Inexistente";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"error_notfound" ofType:@"html" inDirectory:@"HTML"];
        html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    
    if (entries != nil && [entries count] && n > 0) {
        pager.numberOfPages = [entries count];
        pager.currentPage = n - 1;
    } else {
        pager.numberOfPages = 1;
        pager.currentPage = 0;
    }
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [wv loadHTMLString:html baseURL:baseURL];
}


- (void)performTransitionTo:(NSArray *)results atIndex:(int)n {
    
    if (!touchRequest && n == requestN) {
        return;
    }
    
    BOOL transitionForward = NO;
    
    if (touchRequest && [requestEntry caseInsensitiveCompare:touchRequestPreviousEntry] == NSOrderedAscending) {
        transitionForward = YES;
    } else if (n < requestN) {
        transitionForward = YES;
    }
    
    CATransition *transition    = [CATransition animation];
    transition.duration         = 0.5;
    transition.timingFunction   = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type             = (transitionForward) ? kCATransitionMoveIn   : kCATransitionReveal;
    transition.subtype          = (transitionForward) ? kCATransitionFromLeft : kCATransitionFromRight;
    transition.delegate         = self;
    
    [container.layer addAnimation:transition forKey:nil];
    
    requestN = n;
    transitioning = YES;

    [self loadEntry:definitionView2 withArray:results atIndex:n];

    // Switch views only when definitionView2 finishes loading, see webViewDidFinishLoad
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    transitioning = NO;
    touchRequest  = NO;
}


- (IBAction)changePage:(id)sender {
    if (!transitioning) {
        [self performTransitionTo:requestResults atIndex:(pager.currentPage + 1)];
    }
}


- (void)showInfoTable {
    DADelegate *delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];
    InfoTableController *infoTable = [[InfoTableController alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.title style:UIBarButtonItemStyleBordered target:nil action:nil];
    [delegate.navController pushViewController:infoTable animated:YES];
    [infoTable release];
    [self.navigationItem.backBarButtonItem release];
}

#pragma mark -
#pragma mark UIWebViewDelegate Methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Switch only when not transitioning
    if (transitioning && webView == definitionView2) {
        definitionView1.hidden = YES;
        definitionView2.hidden = NO;
        
        UIWebView *tmp = definitionView2;
        definitionView2 = definitionView1;
        definitionView1 = tmp;
        
    } else if (webView == definitionView1) {
        definitionView1.hidden = NO;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)urlRequest navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [urlRequest URL];
        
        if ([[url scheme] isEqualToString:@"aberto"]) {
            // Internal links
            
            if ([[url host] isEqualToString:@"define"]) {
                touchRequest = YES;
                touchRequestPreviousEntry = [requestEntry copy];
                touchRequestPreviousN = requestN;
                
                // Definition links (aberto://define:*/*)
                requestEntry = [[url lastPathComponent] copy];
                requestN     = [[url port] integerValue];
                
                // NSLog(@"Requested %@:%d", requestEntry, requestN);
                [self searchDicionarioAberto:requestEntry];
            }
            return NO;
            
        } else {
            [[UIApplication sharedApplication] openURL:url];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}


- (void)swipeRightAction {
    if (!transitioning && requestN > 1) {
        [self performTransitionTo:requestResults atIndex:(requestN - 1)];
    }
}


- (void)swipeLeftAction {
    if (!transitioning && requestN < [requestResults count]) {
        [self performTransitionTo:requestResults atIndex:(requestN + 1)];
    }
}


- (void)swipeDoesNothingAction {
    // It really does nothing
}


#pragma mark -
#pragma mark DARemoteDelegate Methods


- (void)connectionDidFail:(DARemote *)connection {
    [self loadNoConnection:definitionView1 withString:connection.query];
}


- (void)connectionDidFinish:(DARemote *)connection {
    NSString *response = [[NSString alloc] initWithData:connection.receivedData encoding:NSUTF8StringEncoding];

    requestResults = [[DAParser parseAPIResponse:response list:NO] copy];
    
    if (requestResults && [requestResults count]) {
        [DARemote cacheResult:response forQuery:connection.query ofType:connection.type error:nil];
    }
    
    if (touchRequest) {
        [self performTransitionTo:requestResults atIndex:requestN];
    } else {
        [self loadEntry:definitionView1 withArray:requestResults atIndex:requestN];
    }
    
    [response release];
}

@end
