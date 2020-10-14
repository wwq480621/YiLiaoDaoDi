//
//  YIManager.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/27.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YIManager : NSObject

///自动判断是push还是present 来进行pop或者dismiss
+(void)popVC;
//当前类 是否是 tabbar五个类里面选中的那个类
+ (BOOL)isThatSeletedVC;
//获取当前YIBaseViewController类中的rootView
+ (UIView *)getCurrentVCWithMainView;

+(UIViewController *)getCurrentVC;
+(UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC;

@end

NS_ASSUME_NONNULL_END
