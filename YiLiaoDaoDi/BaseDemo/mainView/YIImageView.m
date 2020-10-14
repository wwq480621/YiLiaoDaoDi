//
//  YIImageView.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIImageView.h"
#import "YIImageDownloadHUD.h"

@interface YIImageView ()
@property (nonatomic, readwrite, strong) NSString *imgUrl;
@property (nonatomic, readwrite, strong) YIImageDownloadHUD *hud;
@property (nonatomic, readwrite, assign) BOOL isDownLoad;       //默认为NO ----还没有下载图片  YES为已经下载完图片


@end


@implementation YIImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.locationView];
    }
    return self;
}

- (YIImageDownloadHUD *)hud
{
    if (!_hud) {
        _hud = [[YIImageDownloadHUD alloc] initWithFrame:self.bounds];
        _hud.progress = 0;
        [self addSubview:_hud];
    }
    return _hud;
}
- (void)downloadImageUrl:(NSString *)imageUrl
{
    [self downloadImageUrl:imageUrl isCache:NO];
}

- (void)downloadImageUrl:(NSString *)imageUrl isCache:(BOOL)cache
{
    [self downloadImageUrl:imageUrl isCache:cache complcationHandler:nil];
}

- (void)downloadImageUrl:(NSString *)imageUrl isCache:(BOOL)cache complcationHandler:(_Null_unspecified downloadImageOK)handler
{
    if(YI_IS_EMPTY_STR(imageUrl)){
        return;
    }
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        //加载进度
        CGFloat resize = receivedSize;
        CGFloat exsize = expectedSize;
        self.hud.progress = resize/exsize;
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.image = image;
        self.isDownLoad = YES;
        //回调图片的宽高 - 也是图片加载完成的通知事件
        if (handler) {
            handler(image.size.width,image.size.height);
        }
    }];
}

- (void)contrastTextLocationUI
{
   if (self.style == YIPhotoViewStyleContrast) {
        //是对比
        self.locationView.dataSource = [YIHomeManager sharedInstance].contrasts;
    }
}


- (YITextLocationView *)locationView
{
    if (!_locationView) {
        _locationView = [[YITextLocationView alloc] initWithFrame:self.frame];
    }
    return _locationView;
}

@end
