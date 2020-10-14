//
//  YINavigationController.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YINavigationController.h"

@interface YINavigationController ()<UINavigationControllerDelegate>

@property (nonatomic,strong) id yinaviDelegate;

@end

@implementation YINavigationController

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //实现滑动返回功能
    //清空滑动返回手势的代理就能实现
    self.interactivePopGestureRecognizer.delegate = viewController == self.viewControllers[0]? self.yinaviDelegate : nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]]; //去除黑线
    
    self.yinaviDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.viewControllers.count > 0)
    {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
   return [super popViewControllerAnimated:animated];
}

@end
