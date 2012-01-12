//
//  DicionarioAbertoAppDelegate.h
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//

@class DASearchController;

@interface DADelegate : NSObject <UIApplicationDelegate> {
    // View controllers
    UIWindow *window;
    UINavigationController *navController;
    DASearchController *searchController;
    
    // Core Data
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

// View controllers
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navController;
@property (nonatomic, strong) IBOutlet DASearchController *searchController;

// Search results
@property (nonatomic, strong) NSArray *searchResults;

// Core Data
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

@end

