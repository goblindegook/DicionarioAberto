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
    UIWindow *window;
    UINavigationController *navController;
    RootController *viewController;
    
    // Core Data
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
    
    NSArray *searchResults;
    NSArray *savedSearchResults;
    NSString *savedSearchText;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootController *viewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) NSArray *searchResults;
@property (nonatomic, retain) NSArray *savedSearchResults;
@property (nonatomic, retain) NSString *savedSearchText;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

//- (void) searchDicionarioAberto:(NSString *)query;

@end

