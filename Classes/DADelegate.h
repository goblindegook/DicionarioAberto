//
//  DicionarioAbertoAppDelegate.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//  Copyright log - Open Source Consulting 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootController;

@interface DADelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootController *viewController;
    NSMutableArray *searchResults;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootController *viewController;
@property (nonatomic, retain) NSMutableArray *searchResults;

@end

