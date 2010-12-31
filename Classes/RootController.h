//
//  DicionarioAbertoViewController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"

#import "DefinitionController.h"
#import "SearchCell.h"

#import "DADelegate.h"
#import "DASearchCache.h"
#import "DAFavourites.h"
#import "DAHistory.h"
#import "DARemote.h"

#import "Entry.h"
#import "EntryForm.h"
#import "EntrySense.h"
#import "EntrySenseUsage.h"
#import "EntryEtymology.h"

@interface RootController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    
    UITableView *searchResultsTable;
    
    OBGradientView *tableHeaderView;
    OBGradientView *tableFooterView;
    
    BOOL searchPrefix;
    BOOL searching;
    BOOL letUserSelectRow;
    
    DADelegate *delegate;
}

@property (nonatomic, retain) IBOutlet UITableView *searchResultsTable;

- (void) searchDicionarioAberto:(NSString *)query;
- (void) dropShadowFor:(UITableView *)tableView;

@end

