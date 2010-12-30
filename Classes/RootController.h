//
//  DicionarioAbertoViewController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"

@interface RootController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    
    UITableView *searchResultsTable;
    
    OBGradientView *tableHeaderView;
    OBGradientView *tableFooterView;
    
    BOOL searchPrefix;
    BOOL searching;
    BOOL letUserSelectRow;
}

@property (nonatomic, retain) IBOutlet UITableView *searchResultsTable;

- (void) searchDicionarioAberto:(NSString *)query;
- (void) dropShadowFor:(UITableView *)tableView;

@end

