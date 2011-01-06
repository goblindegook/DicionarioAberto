//
//  DefinitionController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import <UIKit/UIKit.h>

#import "InfoTableController.h"

#import "DADelegate.h"
#import "DARemote.h"
#import "DAParser.h"

#import "Entry.h"
#import "Form.h"
#import "EntrySense.h"
#import "EntrySenseUsage.h"
#import "EntryEtymology.h"

@interface DefinitionController : UIViewController <UIWebViewDelegate, DARemoteDelegate> {
    DADelegate *delegate;
    IBOutlet UIWebView *definitionView;
    NSIndexPath *index;
}

- (id)initWithIndexPath:(NSIndexPath *)indexPath;
- (void)loadError:(NSString *)query;
- (void)loadEntryFrom:(NSArray *)entries atIndex:(int)n;
- (NSString *)htmlEntryFrom:(NSArray *)entries atIndex:(int)n;

@end
