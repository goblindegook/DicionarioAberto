//
//  DicionarioAbertoViewController.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//  Copyright log - Open Source Consulting 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *searchResultsView;
    NSMutableArray *searchResults;
}

@property (nonatomic, retain) IBOutlet UITableView *searchResultsView;

@end

