//
//  YIImageView.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YITextLocationView.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger , YIPhotoViewStyle) {
    YIPhotoViewStyleDefault         =   0,      //默认展示图片 -- 无
    YIPhotoViewStylePreView         =   1,      //预览 --
    YIPhotoViewStyleContrast        =   2,      //对比 -- 坐标
};

typedef void(^downloadImageOK)(CGFloat imageWidth,CGFloat imageHeight);

@interface YIImageView : UIImageView

@property (nonatomic, readwrite, assign) YIPhotoViewStyle style;
@property (nonatomic, readwrite, strong) YITextLocationView *locationView;

///图片加载 默认为NO 不清楚缓存
- (void)downloadImageUrl:(NSString *)imageUrl;
///图片加载 默认为NO 不清楚缓存  YES为清除缓存 --- 适合(地址不会变的)头像
- (void)downloadImageUrl:(NSString *)imageUrl isCache:(BOOL)cache;
///图片加载 默认为NO 不清楚缓存  YES为清除缓存 --- 适合(地址不会变的)头像  图片加载成功回调(用于需要的场景)
- (void)downloadImageUrl:(NSString *)imageUrl isCache:(BOOL)cache complcationHandler:(_Null_unspecified downloadImageOK)handler;

- (void)contrastTextLocationUI;

@end

NS_ASSUME_NONNULL_END
