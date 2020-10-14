//
//  UITabBarItem+CustomBadge.m
//  PaoPaoClub
//
//  Created by eddy_Mac on 2020/4/7.
//  Copyright © 2020 eddy. All rights reserved.
//

#import "UITabBarItem+CustomBadge.h"
#import <objc/runtime.h>

static NSString * const kCustomBadgeValueKey = @"CustomBadgeValueKey";
static NSInteger const kCustomBadgeTag = 6666;
static NSInteger const kReddotTag = 9999;

@implementation UITabBarItem (CustomBadge)

- (NSString *)customBadgeValue
{
    return objc_getAssociatedObject(self, &kCustomBadgeValueKey);
}

- (void)setCustomBadgeValue:(NSString *)customBadgeValue
{
    if (customBadgeValue.integerValue > 99)
    {
        customBadgeValue = @"99+";
    }
    else if (customBadgeValue.integerValue == 0)
    {
        customBadgeValue = nil;
    }
    
    objc_setAssociatedObject(self, &kCustomBadgeValueKey, customBadgeValue, OBJC_ASSOCIATION_COPY);
    
    // default config
    [self setCustomBadgeValue:customBadgeValue
                         font:[UIFont systemFontOfSize:12.0]
                    textColor:[UIColor whiteColor]
              backgroundColor:nil];
}

- (void)setCustomBadgeValue:(NSString *)value font:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [self valueForKey:@"view"];
    
    UIImageView *itemImageView = nil;
    
    for (UIView *subview in view.subviews)
    {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITabBarSwappableImageView"])
        {
            itemImageView = (UIImageView *)subview;
            
            // REMOVE PREVIOUS IF EXIST
            [[itemImageView viewWithTag:kCustomBadgeTag] removeFromSuperview];
        }
    }
    
    if (itemImageView == nil || value.length == 0)
    {
        return;
    }
    
    UIImage *badgeBackgroundImage = [UIImage imageNamed:@"badge_red"];
    badgeBackgroundImage = [badgeBackgroundImage
                            resizableImageWithCapInsets:UIEdgeInsetsMake(badgeBackgroundImage.size.height / 2,
                                                                         badgeBackgroundImage.size.width / 2,
                                                                         badgeBackgroundImage.size.height / 2,
                                                                         badgeBackgroundImage.size.width / 2)
                            resizingMode:UIImageResizingModeStretch];
    [badgeBackgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImageView *badgeImageView = [[UIImageView alloc] initWithImage:badgeBackgroundImage];
    
    UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    badgeBackgroundImage.size.width - 2,
                                                                    badgeBackgroundImage.size.height - 2)];
    [badgeLabel setFont:font];
    [badgeLabel setText:value];
    [badgeLabel setTextColor:color];
    [badgeLabel setTextAlignment:NSTextAlignmentCenter];
    [badgeLabel sizeToFit];
    badgeLabel.frame = CGRectMake(badgeLabel.frame.origin.x,
                                  badgeLabel.frame.origin.y,
                                  badgeLabel.frame.size.width + 14,
                                  badgeBackgroundImage.size.height);
    
    badgeImageView.frame = CGRectMake(badgeImageView.frame.origin.x,
                                      badgeImageView.frame.origin.y,
                                      badgeLabel.frame.size.width,
                                      badgeImageView.frame.size.height);
    
    [badgeImageView addSubview:badgeLabel];
    badgeImageView.center = CGPointMake(45, badgeBackgroundImage.size.height / 2);
    badgeImageView.tag = kCustomBadgeTag;
    
    [itemImageView addSubview:badgeImageView];
}

- (void)setBadgeValueForReddot:(NSInteger)badgeValueForReddot
{
    UIView *view = [self valueForKey:@"view"];
    
    UIImageView *itemImageView = nil;
    
    for (UIView *subview in view.subviews)
    {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITabBarSwappableImageView"])
        {
            itemImageView = (UIImageView *)subview;
            
            // REMOVE PREVIOUS IF EXIST
            [[itemImageView viewWithTag:kReddotTag] removeFromSuperview];
        }
    }
    
    if (itemImageView == nil || badgeValueForReddot == 0)
    {
        return;
    }
    
    UIImageView *badgeImageView = [[UIImageView alloc] init];
    badgeImageView.backgroundColor = [UIColor redColor];
    badgeImageView.frame = CGRectMake(35, 5, 10, 10);
    badgeImageView.layer.cornerRadius = 5;
    badgeImageView.tag = kReddotTag;
    
    [itemImageView addSubview:badgeImageView];
}

@end
