//
//  DefinitionController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import "DADelegate.h"
#import "DARemoteClient.h"
#import "DAParser.h"

#import "Entry.h"
#import "EntryForm.h"
#import "EntrySense.h"
#import "EntrySenseUsage.h"
#import "EntryEtymology.h"

#import "InfoTableController.h"

@interface DefinitionController : UIViewController <UIWebViewDelegate, UIGestureRecognizerDelegate> {
    IBOutlet UIView *container;
    IBOutlet UIWebView *definitionView1;
    IBOutlet UIWebView *definitionView2;
    IBOutlet UIPageControl *pager;
    
    UISwipeGestureRecognizer *swipeLeft;
    UISwipeGestureRecognizer *swipeRight;
    UISwipeGestureRecognizer *swipeDoesNothing;

    NSMutableArray *requestResults;
    NSMutableString *requestEntry;
    int requestN;

    BOOL touchRequest;
    BOOL transitioning;

    NSMutableString *touchRequestPreviousEntry;
    int touchRequestPreviousN;
}

- (id)initWithRequest:(NSString *)entry atIndex:(int)n;
- (void)searchDicionarioAberto:(NSString *)query;
- (void)loadError:(UIWebView *)wv ofType:(int)searchStatus withString:(NSString *)query;
- (void)loadEntry:(UIWebView *)wv withArray:(NSArray *)entries atIndex:(int)n;
- (void)performTransitionTo:(NSArray *)results atIndex:(int)n;
- (NSString *)htmlEntryFrom:(NSArray *)entries atIndex:(int)n;

- (IBAction)changePage:(id)sender;

- (void)swipeLeftAction;
- (void)swipeRightAction;
- (void)swipeDoesNothingAction;

@end
