//
//  AppDelegate.m
//  Homepwner
//
//  Created by 郑楠 on 15/7/9.
//  Copyright (c) 2015年 zhengnan. All rights reserved.
//

#import "AppDelegate.h"
#import "ItemViewController.h"
#import "ItemStore.h"

NSString * const NextItemValuePrefsKey = @"NextItemValue";
NSString * const NextItemNamePrefsKey = @"NextItemName";

@interface AppDelegate ()

@end

@implementation AppDelegate


+ (void)initialize{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *factorySettings = @{NextItemValuePrefsKey: @75,
                                      NextItemNamePrefsKey: @"Coffee Cup"};
    
    [defaults registerDefaults:factorySettings];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (!self.window.rootViewController) {
        ItemViewController *itemsViewController = [[ItemViewController alloc] init];
    
        UINavigationController *navController = [[UINavigationController alloc]
                                                 initWithRootViewController:itemsViewController];
    
        // Give the navigation controller a restoration identifier that is
        // the same name as the class
        navController.restorationIdentifier = NSStringFromClass([navController class]);
    
        self.window.rootViewController = navController;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder{

    //Create a new navigation controller
    UIViewController *vc = [[UINavigationController alloc] init];
    
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    if ([identifierComponents count] == 1) {
        self.window.rootViewController = vc;
    }
    return vc;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    BOOL success = [[ItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the Items");
    }else{
        NSLog(@"Could not save any of the Items");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    
    return YES;
}

@end
