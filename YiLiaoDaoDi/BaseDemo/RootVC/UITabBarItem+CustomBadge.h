//
//  UITabBarItem+CustomBadge.h
//  PaoPaoClub
//
//  Created by eddy_Mac on 2020/4/7.
//  Copyright © 2020 eddy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarItem (CustomBadge)

@property (nonatomic, copy) NSString *customBadgeValue;

@property (nonatomic, assign) NSInteger badgeValueForReddot;

@end

NS_ASSUME_NONNULL_END
