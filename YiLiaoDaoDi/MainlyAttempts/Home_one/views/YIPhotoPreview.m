//
//  YIPhotoPreview.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIPhotoPreview.h"

@interface YIPhotoPreview () <UIScrollViewDelegate>

@property (nonatomic, readwrite, strong) NSArray *dataSource;

@property (nonatomic, readwrite, strong) UIView *mainView;  //承载view 动画操作的view
@property (nonatomic, readwrite, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *saveItem;

@property (nonatomic, readwrite, strong) NSMutableArray *items;

//位置保存
@property (nonatomic, readwrite, assign) CGRect selectedFrame;

@end




@implementation YIPhotoPreview

+ (YIPhotoPreview *)photoPreviewWithArray:(NSArray<YIPhotoMode *> *)array style:(YIPhotoViewStyle)style
{
    YIPhotoPreview *photoPre = [[YIPhotoPreview alloc] init];
    photoPre.style = style;
    photoPre.dataSource = array;
    
    return photoPre;
}
+ (YIPhotoPreview *)photoPreviewWithArray:(NSArray<YIPhotoMode *> *)array
{
    YIPhotoPreview *photoPre = [[YIPhotoPreview alloc] init];
    photoPre.dataSource = array;
    
    return photoPre;
}

- (instancetype)init
{
    self = [self initWithFrame:CGRectMake(0, 0, YIScreen_Width, YIScreen_Height)];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setNeedsUpdateUI];
    }
    return self;
}

- (void)setNeedsUpdateUI
{
    [self addSubview:self.mainView];
    [self.mainView addSubview:self.scrollView];
    [self.mainView addSubview:self.saveItem];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
}

- (void)setNeedsUpdateData
{
    [self initWithPhotoViews];
    
    [self.scrollView setContentSize:CGSizeMake(YIScreen_Width*self.dataSource.count, 0)];
}

- (void)initWithPhotoViews
{
    for (int i=0; i< self.dataSource.count; i++) {
        //初始化图片
        YIPhotoMode *mode = self.dataSource[i];
        YIPhotoView *photo = [self photoWithImage:mode.normalImage imgurl:nil];
        
        photo.category_left = YIScreen_Width*i;
        [self.scrollView addSubview:photo];
        [self.items addObject:photo];
        
        [photo addTapGestureBlock:^(UIGestureRecognizer * _Nonnull sender) {
            //点击事件 --
            [self hide];
        }];
    }
}

- (YIPhotoView *)photoWithImage:(UIImage *)image imgurl:(NSString *)imgUrl
{
    YIPhotoView *photo = [[YIPhotoView alloc] init];
    photo.style = self.style;
    if (!YI_IS_EMPTY_IMAGE(image)) {
        photo.image = image;
    }
    if (!YI_IS_EMPTY_STR(imgUrl)) {
        photo.imageURL = imgUrl;
    }
    return photo;
}

- (void)setSelectedCurrent:(int)selectedCurrent
{
    _selectedCurrent = selectedCurrent;
    
    [self.scrollView setContentOffset:CGPointMake(YIScreen_Width*_selectedCurrent, 0) animated:NO];
    
    YIPhotoMode *mode = self.dataSource[selectedCurrent];
    YIPhotoView *photo = self.items[selectedCurrent];
    //加载当前图片
    photo.image = mode.normalImage;
    photo.imageURL = mode.imgUrl;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
    [self setNeedsUpdateData];
    
    self.selectedCurrent = 0;
}


- (void)show
{
    //展示图片浏览器
    //初始化
    self.category_left = YIScreen_Width;
    
    [YIWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.category_left = 0;
    }];
}

- (void)hide
{
    //退出图片浏览器
    //判断是否是showToView进入的
    if (self.selectedFrame.size.width == 0 || self.selectedFrame.size.height == 0) {
        //不是从showToView进入的
        //移除
        [UIView animateWithDuration:0.3 animations:^{
            self.category_left = YIScreen_Width;
        } completion:^(BOOL finished) {
            [self removeAllSubviews];
            [self removeFromSuperview];
        }];
    }else {
        //获取当前观看到的视图
        YIPhotoMode *mode = self.dataSource[_selectedCurrent];
        UIView *view = mode.originalView;
        
        [self hideToView:view];
    }
    
}

- (void)showToView:(UIView *)view
{
    //是在哪里出现的 ---
    //获取view在屏幕上的位置 ---
    CGRect frame = [view convertRect:view.bounds toView:YIWindow];
    self.selectedFrame = frame;
    //根据当前位置进行动画操作 --
    //先设置self.mainView的size和位置为view的屏幕坐标位置
    [self.mainView setFrame:frame];
    //设置self的
    self.category_left = 0;
    //进行动画
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.frame = self.frame;
    }];
}

- (void)hideToView:(UIView *)view
{
    if (!view) {
        [self hide];
        return;
    }
    CGRect frame = [view convertRect:view.bounds toView:YIWindow];
    self.selectedFrame = frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mainView.frame = self.selectedFrame;
    } completion:^(BOOL finished) {
        [self removeAllSubviews];
        [self removeFromSuperview];
    }];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hide];
}


- (UIView *)mainView
{
    if (!_mainView) {
        UIView *view = [[UIView alloc] initWithFrame:self.frame];
        view.backgroundColor = [UIColor blackColor];
        
        _mainView = view;
    }
    return _mainView;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIButton *)saveItem
{
    if (!_saveItem) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.titleLabel.font = kTextFontName(titleFontBold, 15);
        [button setTitle:@"保存" forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(moreFunction) forControlEvents:(UIControlEventTouchUpInside)];
        
        button.frame = CGRectMake(YIScreen_Width - 76, 20, 60, 30);
        _saveItem = button;
    }
    return _saveItem;
}

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray new];
    }
    return _items;
}


- (void)moreFunction
{
    //保存
    YIPhotoView *photoView = self.items[_selectedCurrent];
    
    UIGraphicsBeginImageContext(photoView.image.size);
    [photoView.photo drawViewHierarchyInRect:CGRectMake(0, 0, photoView.image.size.width, photoView.image.size.height) afterScreenUpdates:NO];
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
       
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [[YIManager getCurrentVC] showViewController:alert sender:nil];
}


@end
