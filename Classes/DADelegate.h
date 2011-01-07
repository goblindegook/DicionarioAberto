//
//  DicionarioAbertoAppDelegate.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

#import <UIKit/UIKit.h>

#import "DASearchCache.h"
#import "DAFavourites.h"
#import "DAHistory.h"
#import "DARemote.h"

#import "Entry.h"
#import "EntryForm.h"
#import "EntrySense.h"
#import "EntrySenseUsage.h"
#import "EntryEtymology.h"

@class RootController;

@interface DADelegate : NSObject <UIApplicationDelegate> {
    // View controllers
    UIWindow *window;
    UINavigationController *navController;
    RootController *searchController;
    
    // Search results
    NSArray *searchResults;
    NSArray *savedSearchResults;
    NSString *savedSearchText;
    
    // Core Data
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

// View controllers
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet RootController *searchController;

// Search results
@property (nonatomic, retain) NSArray *searchResults;
@property (nonatomic, retain) NSArray *savedSearchResults;
@property (nonatomic, retain) NSString *savedSearchText;

// Core Data
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@end

