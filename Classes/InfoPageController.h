//
//  InfoPageController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 04/01/2011.
//

#import "DADelegate.h"

@interface InfoPageController : UIViewController <UIWebViewDelegate> {
    DADelegate *delegate;
    IBOutlet UIWebView *infoPageView;
    NSString *pageTitle;
    NSURL *pageURI;
    BOOL mainViewHasLoaded;
}

- (id)initWithURI:(NSURL *)theURI title:(NSString *)theTitle;
- (void)webView:(UIWebView *)wv loadURI:(NSURL *)url;

@end
