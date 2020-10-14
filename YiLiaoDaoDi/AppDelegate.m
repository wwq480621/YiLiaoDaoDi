//
//  AppDelegate.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/6/29.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "YITabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    [self.window setRootViewController:[ViewController new]];
    
    [self performSelector:@selector(showMainVC) withObject:self afterDelay:3.0];
    
    return YES;
}

- (void)showMainVC
{
    //
    YITabBarController *rootController = [[YITabBarController alloc] init];
    
    [self.window setRootViewController:rootController];
    
    [self.window makeKeyAndVisible];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

@end
