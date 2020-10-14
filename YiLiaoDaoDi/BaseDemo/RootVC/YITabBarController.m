//
//  YITabBarController.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YITabBarController.h"
#import "UITabBarItem+CustomBadge.h"

#import "YIHomeViewController.h"
#import "YIClassViewController.h"
#import "YIWareViewController.h"
#import "YIUserInfoViewController.h"


@interface YITabBarController () <UITabBarControllerDelegate>

@end

@implementation YITabBarController

+ (instancetype)currentTabBarController
{
    id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
    
    UIViewController *viewController = appDelegate.window.rootViewController;
    
    if (![viewController isKindOfClass:[UITabBarController class]])
    {
        return nil;
    }
    
    return (YITabBarController *)viewController;
}

+ (UIViewController *)viewControllerWithIndex:(NSInteger)index
{
    return [YITabBarController currentTabBarController].viewControllers[index];
}

+ (void)updateDiantaiBadgeWithBadge:(NSInteger)badgeNumber
{
    [self viewControllerWithIndex:1].tabBarItem.customBadgeValue = [NSString stringWithFormat:@"%ld",badgeNumber];
}

+ (void)updateMessageBadgeWithBadge:(NSInteger)badgeNumber
{
    [self viewControllerWithIndex:3].tabBarItem.customBadgeValue = [NSString stringWithFormat:@"%ld",badgeNumber];;
}

+ (void)updateMineBadgeWithBadge:(NSInteger)badgeNumber
{
    [self viewControllerWithIndex:4].tabBarItem.badgeValueForReddot = badgeNumber;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setTranslucent:NO];
    [self setUpChildController];
}

- (void)setUpChildController
{
    //0x8bd180
    //0x515151
    
    YIHomeViewController *homeVC = [[YIHomeViewController alloc] init];
    homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"讯之华"
                                                      image:[[UIImage imageNamed:@"chat-history-line"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:@"chat-history-fill"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    YIClassViewController *classVC = [[YIClassViewController alloc] init];
    classVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"华之食"
                                                      image:[[UIImage imageNamed:@"apps-line"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:@"apps-fill"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    YIWareViewController *cartVC = [[YIWareViewController alloc] init];
    cartVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"食之仓"
                                                      image:[[UIImage imageNamed:@"heart-three-line"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:@"heart-three-fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    YIUserInfoViewController *myVC = [[YIUserInfoViewController alloc] init];
    myVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"仓之主"
                                                      image:[[UIImage imageNamed:@"account-circle-line"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                              selectedImage:[[UIImage imageNamed:@"account-circle-fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    [self setTitleTextAttributeTabbarItem:homeVC.tabBarItem];
    [self setTitleTextAttributeTabbarItem:classVC.tabBarItem];
    [self setTitleTextAttributeTabbarItem:cartVC.tabBarItem];
    [self setTitleTextAttributeTabbarItem:myVC.tabBarItem];
    
    [self setViewControllers:@[homeVC,
                               classVC,
                               cartVC,
                               myVC
    ]];
}

- (void)setTitleTextAttributeTabbarItem:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:kTextFontName(titleFontBold, 12),NSForegroundColorAttributeName:YICOLOR_WITH_HEX(0x515151)} forState:(UIControlStateNormal)];
    
    [tabBarItem setTitleTextAttributes:@{NSFontAttributeName:kTextFontName(titleFontBold, 12),NSForegroundColorAttributeName:YICOLOR_WITH_HEX(0x8bd180)} forState:(UIControlStateSelected)];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
