//
//  YIBaseViewController.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YIBaseViewController : UIViewController {
    int  _page;
}

@property (nonatomic, readwrite, strong) UIView *navi;
@property (nonatomic, readwrite, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *rootView;


@property (nonatomic, readwrite, strong) NSString *naviTitle;
@property (nonatomic, readwrite, strong) UIColor *naviTitleColor;
@property (nonatomic, readwrite, strong) UIFont *naviTitleFont;

@property (nonatomic, readwrite, strong) YIUserObject *user;

///显示返回按钮
- (void)showNavigationBackItem;
///左侧按钮 image 或者 title
- (void)showNavigationLeftImageName:(NSString *)imageName setTitle:(NSString *)title setTitleColor:(UIColor *)color setSelect:(SEL)selected;
///右侧按钮 image 或者 title
- (void)showNavigationRightImageName:(NSString *)imageName setTitle:(NSString *)title setTitleColor:(UIColor *)color setSelect:(SEL)selected;
//清除左侧按钮
- (void)removeLeftItem;
//返回事件
- (void)navigationBackEvent;
-(void)actionQuit;
///mainView
- (UIView *)custemMainView;

//显示或者隐藏navi底部黑线
- (void)showNaviLine:(BOOL)bol;
///是否显示navi 默认为YES显示        在子类中实现可以控制
- (BOOL)isNavigationHidden;
///bottom高度设置 默认为0      在子类中实现可以控制
- (CGFloat)isCustenMainViewBottomHeight;

//初始化UI
- (void)setupUseInterface;
//初始数据加载
- (void)requestRefreshDataSource;
//更多数据加载
- (void)requestMoreRefreshDataSource;

//有没有更多数据
- (BOOL)isMore:(NSInteger)count isSize:(NSInteger)p_size;

@end

NS_ASSUME_NONNULL_END
