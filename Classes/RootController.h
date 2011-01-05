//
//  DicionarioAbertoViewController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"

#import "SearchCell.h"
#import "DefinitionController.h"
#import "InfoTableController.h"

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
    DADelegate *delegate;
    
    UITableView *searchResultsTable;
    
    OBGradientView *tableHeaderView;
    OBGradientView *tableFooterView;
    
    BOOL searchPrefix;
    BOOL searching;
    BOOL letUserSelectRow;

    int searchStatus;
}

@property (nonatomic, retain) IBOutlet UITableView *searchResultsTable;

- (void)dropShadowFor:(UITableView *)tableView enabled:(BOOL)enabled;
- (void)searchDicionarioAberto:(NSString *)query;
- (void)searchDicionarioAbertoSelector:(NSString *)query;
- (void)showInfoTable;

- (void)setSearchResultsOnMainThread:(NSArray *)results;
- (void)setSavedSearchResultsOnMainThread:(NSArray *)results;
- (void)reloadSearchDataOnMainThread;

@end

