//
//  YIAnimationHUD.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/23.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YIAnimationHUDStyle) {
    YIAnimationHUDStyleDefault              =       0,      //默认样式 菊花
    YIAnimationHUDStyleGIF                  =       1,      //gif动画
    YIAnimationHUDStyleFrameAnimation       =       2,      //帧动画 图片帧动画
    YIAnimationHUDStyleJSONAnimation        =       3,      //json动画
    YIAnimationHUDStyleFlashAnimation       =       4,      //模仿今日头条 字体闪动加载
};

typedef NS_ENUM(NSInteger,YIAnimationHUDType) {
    YIAnimationHUDTypeTiming        = 0,            //定时 默认时间为2s
    YIAnimationHUDTypeLong          = 1,            //不定时 需要手动关闭
};

@interface YIAnimationHUD : UIView

YI_SHARED_DEFINE(YIAnimationHUD)


@property (nonatomic, readwrite, assign) YIAnimationHUDStyle style;
@property (nonatomic, readwrite, assign) YIAnimationHUDType timeType;


//是否正在显示中
@property (nonatomic, readwrite, assign) BOOL isAnimation;
//设置的最大时间
@property (nonatomic, readwrite, assign) int maximumTime;

@property (nonatomic, readwrite, assign) int timeout;

@property (nonatomic, readwrite, assign) BOOL enable;


///开启动画 - 选择动画类型 默认为NO允许交互  0、1、2、3、4
+ (YIAnimationHUD *)showAnimationStyle:(NSInteger)style;
///开启动画 - 选择动画类型 是否禁止交互  默认网络延迟为10s  NO允许交互 YES不允许交互  0、1、2、3、4
+ (YIAnimationHUD *)showAnimationStyle:(NSInteger)style enableUserInteration:(BOOL)isEnable;
///开启动画 - 选择动画类型  设置网络延迟多少s停止loading   是否禁止交互 NO允许交互 YES不允许交互  0、1、2、3、4
+ (YIAnimationHUD *)showAnimationStyle:(NSInteger)style isMaximumTime:(int)maximumTime enableUserInteration:(BOOL)isEnable;
///关闭动画
+ (void)hideAnimationStyle;

@end

NS_ASSUME_NONNULL_END
