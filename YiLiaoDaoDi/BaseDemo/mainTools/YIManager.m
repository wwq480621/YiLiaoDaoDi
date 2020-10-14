//
//  YIManager.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/27.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIManager.h"
#import "YIBaseViewController.h"

@implementation YIManager

+(void)popVC
{
    UIViewController *vc = [self getCurrentVC];
    
    if (vc.presentingViewController && vc.navigationController.viewControllers.count == 1) {
        [vc dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (vc.tabBarController.selectedViewController == vc) {
            return;
        }
        [vc.navigationController popViewControllerAnimated:YES];
    }
}

+ (UIView *)getCurrentVCWithMainView
{
    YIBaseViewController *vc = (YIBaseViewController *)[self getCurrentVC];
    
    return vc.rootView;
}

+ (BOOL)isThatSeletedVC
{
    UIViewController *vc = [self getCurrentVC];
    if (vc.tabBarController.selectedViewController == vc) {
        return YES;
    }
    return NO;
}

+(UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+(UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
      
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {

        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
     
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
       
     
        currentVC = rootVC;
    }
    
    return currentVC;
}


@end
