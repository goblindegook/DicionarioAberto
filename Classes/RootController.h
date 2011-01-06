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
#import "DARemote.h"
#import "DAParser.h"

#import "Entry.h"

@interface RootController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, DARemoteDelegate> {
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
- (void)reloadSearchResultsTable;
- (void)showInfoTable;


@end

