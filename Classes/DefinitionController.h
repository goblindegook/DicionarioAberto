//
//  DefinitionController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import <UIKit/UIKit.h>

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
    DADelegate *delegate;
    IBOutlet UIWebView *definitionView;
    NSIndexPath *index;
    
    NSString *requestedEntry;
    int requestedN;
}

@property (nonatomic, copy) NSString *requestedEntry;
@property (readwrite, assign) int requestedN;

- (id)initWithIndexPath:(NSIndexPath *)indexPath;
- (void)loadNoConnection:(NSString *)query;
- (void)loadEntryFrom:(NSArray *)entries atIndex:(int)n;
- (NSString *)htmlEntryFrom:(NSArray *)entries atIndex:(int)n;

@end
