//
//  AppDelegate.m
//  SPLImage
//
//  Created by Girish Rathod on 06/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "TemplateViewController.h"
#import "Flurry.h"
#import "FlurryAds.h"
#import "KeychainItemWrapper.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize templateViewController = _templateViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // Override point for customization after application launch.
    self.templateViewController = [[TemplateViewController alloc] initWithNibName:@"TemplateViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.templateViewController];
    self.window.rootViewController = navController;

    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"KJQGGC4HZP6Q87NPJJ92"];
    [FlurryAds initialize:self.window.rootViewController];
  
    //for splash to appear longer
    [NSThread sleepForTimeInterval:2];

    if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled"))
        NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
    
    
    
    [self.window makeKeyAndVisible];
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"SplImageYoutubeCredentials" accessGroup:nil];
    [keychainItem resetKeychainItem];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [Flurry logEvent:@"Splimage App Launched" timed:YES];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{

}// try to clean up as much memory as possible. next step is to terminate app
@end
