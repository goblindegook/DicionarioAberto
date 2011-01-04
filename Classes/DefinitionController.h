//
//  DefinitionController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 21/12/2010.
//

#import <UIKit/UIKit.h>

#import "DADelegate.h"
#import "DAMarkup.h"
#import "DARemote.h"

#import "TouchXML.h"

#import "Entry.h"
#import "Form.h"
#import "EntrySense.h"
#import "EntrySenseUsage.h"
#import "EntryEtymology.h"

@interface DefinitionController : UIViewController <UIWebViewDelegate> {
    NSIndexPath *index;
    IBOutlet UIWebView *definitionView;
    DADelegate *delegate;
    NSManagedObjectContext *managedObjectContext;
}

-(id)initWithIndexPath:(NSIndexPath *)indexPath;
-(NSString *)htmlEntries:(NSArray *)entries;
-(NSString *)htmlEntries:(NSArray *)entries n:(NSInteger)n;

@end
