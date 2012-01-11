//
//  InfoPageController.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 04/01/2011.
//

#import "InfoPageController.h"
#import "SVProgressHUD.h"

@implementation InfoPageController

#pragma mark Instance Methods

- (id)initWithURI:(NSURL *)theURI title:(NSString *)theTitle {
    if (self == [super init]) {
        pageURI     = theURI;
        pageTitle   = theTitle;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    delegate = (DADelegate *)[[UIApplication sharedApplication] delegate];

    mainViewHasLoaded = NO;
    
    [self webView:infoPageView loadURI:pageURI];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
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




#pragma mark -
#pragma mark UIWebViewDelegate Methods


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.hidden = NO;
    [SVProgressHUD dismiss];
    mainViewHasLoaded = YES;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)urlRequest navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [urlRequest URL];
        
        if ([[url scheme] isEqualToString:@"aberto"]) {
            // Internal links
            
            if ([[url host] isEqualToString:@"define"]) {
                // Definition links (aberto://define:*/*)
                // TODO?
                
            } else if ([[url host] isEqualToString:@"static"]) {
                // Static page links (aberto://static/*)
                pageURI = url;
                [self webView:infoPageView loadURI:pageURI];
            }
            
            return NO;
            
        } else if ([[url scheme] isEqualToString:@"file"] &&
                   ([[url fragment] hasPrefix:@"fn"] || [[url fragment] hasPrefix:@"rfn"])) {
            // Footnote links
            return YES;
            
        } else {
            [[UIApplication sharedApplication] openURL:url];
            return NO;
        }
    }
    
    return YES;
}


- (void)webView:(UIWebView *)wv loadURI:(NSURL *)url {
    wv.hidden = YES;
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:[[url pathComponents] lastObject] ofType:nil];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    self.title = pageTitle;
    mainViewHasLoaded = NO;
    
    [wv loadHTMLString:html baseURL:baseURL];
}


@end
