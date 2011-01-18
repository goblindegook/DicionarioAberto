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

@interface DefinitionController : UIViewController <UIWebViewDelegate, DARemoteDelegate> {
    
    IBOutlet UIScrollView *definitionScrollView;
    IBOutlet UIWebView *prevDefinitionView;
    IBOutlet UIWebView *nextDefinitionView;
    
    IBOutlet UIWebView *definitionView;
    NSString *requestedEntry;
    int requestedN;
}

@property (nonatomic, copy) NSString *requestedEntry;
@property (readwrite, assign) int requestedN;

- (id)initWithRequest:(NSString *)entry atIndex:(int)n;
- (void)searchDicionarioAberto:(NSString *)query;
- (void)loadNoConnection:(UIWebView *)wv withString:(NSString *)query;
- (void)loadEntry:(UIWebView *)wv withArray:(NSArray *)entries atIndex:(int)n;
- (NSString *)htmlEntryFrom:(NSArray *)entries atIndex:(int)n;

@end
