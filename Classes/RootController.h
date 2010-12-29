//
//  DicionarioAbertoViewController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface RootController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate> {
    
    UITableView *searchResultsView;
    
    UISearchDisplayController *searchDisplayController;
    
    UIView *tableHeaderView;
    UIView *tableFooterView;
    
    BOOL searchPrefix;
    BOOL searching;
    BOOL letUserSelectRow;
}

@property (nonatomic, retain) IBOutlet UITableView *searchResultsView;

- (void) changeScopeDicionarioAberto:(NSInteger)selectedScope;
- (void) searchDicionarioAberto:(NSString *)searchText;
- (UIView *) gradientShadowOnView:(UIView *)view height:(int)height from:(id)from to:(id)to;
- (void) dropShadow:(UITableView *)tableView;

@end

