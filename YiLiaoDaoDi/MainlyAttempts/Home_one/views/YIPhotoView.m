//
//  YIPhotoView.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIPhotoView.h"

@interface YIPhotoView ()<UIScrollViewDelegate>

@property (nonatomic, readwrite, strong) UIScrollView *scrollView;

@property (nonatomic, readwrite, assign) CGFloat imageNormalWidth;
@property (nonatomic, readwrite, assign) CGFloat imageNormalHeight;

@property (nonatomic, readwrite, assign) CGFloat imageShowHeight;
@end


@implementation YIPhotoView


- (instancetype)init
{
    self = [self initWithFrame:CGRectMake(0, 0, YIScreen_Width, YIScreen_Height)];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithNormalSizeWidth:YIScreen_Width height:YIScreen_Height];
        [self setNeedsUpdateUI];
    }
    return self;
}

- (void)setNeedsUpdateUI
{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.photo];
    
}

- (void)setImage:(UIImage *)image
{
    if (YI_IS_EMPTY_IMAGE(image)) {
        return;
    }
    //直接设置图片 -- 不触发加载
    _image = image;
    self.photo.image = image;
    [self initWithNormalSizeWidth:image.size.width height:image.size.height];
    self.photo.style = self.style;
    [self.photo contrastTextLocationUI];
}

- (void)setImageURL:(NSString *)imageURL
{
    if (YI_IS_EMPTY_STR(imageURL)) {
        return;
    }
    //设置图片地址 -- 执行下载操作 --
    _imageURL = imageURL;
    
    WeakSelf(self);
    [self.photo downloadImageUrl:imageURL isCache:NO complcationHandler:^(CGFloat imageWidth, CGFloat imageHeight) {
        StrongSelf(self);
        [self initWithNormalSizeWidth:imageWidth height:imageHeight];
        self.photo.style = self.style;
        [self.photo contrastTextLocationUI];
    }];
}

- (void)initWithNormalSizeWidth:(CGFloat)imgw height:(CGFloat)imgh
{
    self.imageNormalWidth = imgw;
    self.imageNormalHeight = imgh;
    
    //重新设置图片的frame
    CGFloat left = 0;
    CGFloat top = 0;
    
    CGFloat maxWidth = YIScreen_Width;
    CGFloat scale = maxWidth/imgw;
    CGFloat maxHeight = scale*imgh;
    
    top = YIScreen_Height/2 - maxHeight/2;
    if (top < 0) {
        top = 0;
    }
    self.imageShowHeight = maxHeight;
    self.photo.frame = CGRectMake(left, top, maxWidth, maxHeight);
    self.photo.locationView.frame = CGRectMake(0, 0, maxWidth, maxHeight);
}



- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 4;
        _scrollView.minimumZoomScale = 0.5;
    }
    return _scrollView;
}

- (YIImageView *)photo
{
    if (!_photo) {
        _photo = [[YIImageView alloc] initWithFrame:self.frame];
        _photo.contentMode = UIViewContentModeScaleAspectFit;
        _photo.userInteractionEnabled = YES;
    }
    return _photo;
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photo;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    //开始缩放
}

//缩放中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//    // 延中心点缩放
//    CGFloat imageScaleWidth = scrollView.zoomScale * self.imageNormalWidth;
//    CGFloat imageScaleHeight = scrollView.zoomScale * self.imageNormalHeight;
//
//    CGFloat imageX = 0;
//    CGFloat imageY = 0;
//    imageX = floorf((self.frame.size.width - imageScaleWidth) / 2.0);
//    imageY = floorf((self.frame.size.height - imageScaleHeight) / 2.0);
//    self.photo.frame = CGRectMake(imageX, imageY, imageScaleWidth, imageScaleHeight);
//    self.locationView.frame = CGRectMake(imageX, imageY, imageScaleWidth, imageScaleHeight);
    self.photo.transform = CGAffineTransformMakeScale(scrollView.zoomScale, scrollView.zoomScale);
//    self.locationView.transform = CGAffineTransformMakeScale(scrollView.zoomScale, scrollView.zoomScale);
    [self.scrollView setContentSize:CGSizeMake(scrollView.zoomScale * YIScreen_Width, scrollView.zoomScale * self.imageShowHeight + self.photo.category_top*2)];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //缩放结束
}

@end
