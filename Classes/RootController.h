//
//  DicionarioAbertoViewController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import "SearchCell.h"
#import "DefinitionController.h"
#import "InfoTableController.h"

#import "DADelegate.h"
#import "DARemoteClient.h"
#import "DAParser.h"

#import "Entry.h"

@interface RootController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    DADelegate *delegate;
    
    UITableView *searchResultsTable;
    DARemoteClient *connection;
    
    BOOL searchPrefix;
    BOOL searching;
    BOOL letUserSelectRow;
    BOOL tableHasShadow;

    int searchStatus;
}

@property (nonatomic, strong) IBOutlet UITableView *searchResultsTable;

- (void)dropShadowFor:(UITableView *)tableView;
- (void)searchDicionarioAberto:(NSString *)query;
- (void)reloadSearchResultsTable:(UITableView *)tableView;
- (void)showInfoTable;
- (void)keyboardDidHide:(NSNotification *)notification;

@end

