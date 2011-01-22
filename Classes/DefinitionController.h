//
//  DefinitionController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "DADelegate.h"
#import "DARemote.h"
#import "DAParser.h"

#import "Entry.h"
#import "Form.h"
#import "EntrySense.h"
#import "EntrySenseUsage.h"
#import "EntryEtymology.h"

#import "InfoTableController.h"
#import "OBGradientView.h"

@interface DefinitionController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate, DARemoteDelegate> {
    IBOutlet UIView *container;
    IBOutlet UIWebView *definitionView1;
    IBOutlet UIWebView *definitionView2;
    IBOutlet UIPageControl *pager;
    IBOutlet UIView *activityIndicator;
    IBOutlet OBGradientView *navBarShadow;
    
    UISwipeGestureRecognizer *swipeLeft;
    UISwipeGestureRecognizer *swipeRight;

    NSMutableArray *requestResults;
    NSMutableString *requestEntry;
    int requestN;
    BOOL transitioning;
}

- (id)initWithRequest:(NSString *)entry atIndex:(int)n;
- (void)searchDicionarioAberto:(NSString *)query;
- (void)loadNoConnection:(UIWebView *)wv withString:(NSString *)query;
- (void)loadEntry:(UIWebView *)wv withArray:(NSArray *)entries atIndex:(int)n;
- (NSString *)htmlEntryFrom:(NSArray *)entries atIndex:(int)n;

- (IBAction)changePage:(id)sender;

- (void)swipeLeftAction;
- (void)swipeRightAction;

@end
