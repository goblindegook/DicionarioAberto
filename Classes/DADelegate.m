//
//  DicionarioAbertoAppDelegate.m
//  DicionarioAberto
//
//  Created by Luís Rodrigues on 20/12/2010.
//  Copyright log - Open Source Consulting 2010. All rights reserved.
//

#import "DADelegate.h"
#import "RootController.h"

#import "SuperEntry.h"
#import "Entry.h"
#import "Form.h"
#import "Sense.h"
#import "Usage.h"
#import "Etym.h"

@implementation DADelegate

@synthesize window;
@synthesize viewController;
@synthesize searchResults;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    Entry *palavra = [[Entry alloc] init];
    palavra.entryId = [[NSMutableString alloc] initWithString:@"palavra"];
    
    palavra.entryForm = [[Form alloc] init];
    [palavra entryForm].orth = [[NSMutableString alloc] initWithString:@"Palavra"];

    palavra.entryEtym = [[Etym alloc] init];
    [palavra entryEtym].ori = [[NSMutableString alloc] initWithString:@"lat"];
    [palavra entryEtym].text = [[NSMutableString alloc] initWithString:@"(Do lat. _parabola_)"];
    
    palavra.entrySense = [[NSMutableArray alloc] init];
    
    Sense *palavraSense = [[Sense alloc] init];
    palavraSense.ast = 1;
    palavraSense.def = [[NSMutableString alloc] initWithString:@"Som articulado, que tem um sentido ou significação.\nVocábulo; termo.\nDicção ou phrase.\nAffirmação.\nFala, faculdade de exprimir as ideias por meio da voz.\nO discorrer.\nDeclaração.\nPromessa verbal: _não falto, dou-lhe a minha palavra_.\nPermissão de falar: _peço a palavra_."];
    palavraSense.gramGrp = [[NSMutableString alloc] initWithString:@"f."];
    
    [palavra.entrySense addObject:palavraSense];
    
    self.searchResults = [[NSMutableArray alloc]
                          initWithObjects:palavra, nil];
    
    [palavra release];
    
    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [searchResults release];
    [super dealloc];
}


@end
