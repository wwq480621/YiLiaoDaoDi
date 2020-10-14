//
//  YIAnimationHUD.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/23.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIAnimationHUD.h"
#import "YIFlashMoudule.h"
#import <lottie_ios_Oc/Lottie.h>


#define indiSize CGSizeMake(50,50)

#define gifSize CGSizeMake(140, 140)
#define jsonSize CGSizeMake(140, 140)

#define flashSize CGSizeMake(160, 60)

@interface YIAnimationHUD ()

//最中心需要展示的加载动画承载View
@property (nonatomic, readwrite, strong) UIView *centerView;

//菊花 默认
@property (nonatomic, readwrite, strong) UIActivityIndicatorView *indicatorView;

//帧动画 图片帧
@property (nonatomic, readwrite, strong) UIImageView *pictureHeart;

//gif动画
@property (nonatomic, readwrite, strong) UIImageView  *lottieHGif;

//json动画
@property (nonatomic, readwrite, strong)LOTAnimationView  *lottieHeart;

//闪动动画
@property (nonatomic, readwrite, strong) YIFlashMoudule *flashMoudule;

@end




@implementation YIAnimationHUD

YI_SHARED_IMPLEMENT(YIAnimationHUD)

+ (YIAnimationHUD *)showAnimationStyle:(NSInteger)style
{
    YIAnimationHUD *hud = [YIAnimationHUD showAnimationStyle:style enableUserInteration:NO];
    
    return hud;
}

+ (YIAnimationHUD *)showAnimationStyle:(NSInteger)style enableUserInteration:(BOOL)isEnable
{
    YIAnimationHUD *hud = [YIAnimationHUD showAnimationStyle:style isMaximumTime:100 enableUserInteration:isEnable];
    
    return hud;
}

+ (YIAnimationHUD *)showAnimationStyle:(NSInteger)style isMaximumTime:(int)maximumTime enableUserInteration:(BOOL)isEnable
{
    YIAnimationHUD *hud = [YIAnimationHUD sharedInstance];
    
    if (hud.isAnimation) {
        //正在显示中。。。
        //加入Thread队列  或者 不响应这次动画
        //暂时不响应
        
    } else {
        hud.isAnimation = YES;

        hud.maximumTime = maximumTime;
        hud.style = style;
        hud.enable = isEnable;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud show];
            //开始计时 -----  网络请求不超过 maximunTime设置的时间 超过就取消loading
            [hud startTheTimer];
        });
    }
    return hud;
}


- (void)startTheTimer
{
    self.timeout = 0;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (self.timeout >= self.maximumTime) {
            
            //取消dispatch源
            dispatch_source_cancel(timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新主界面的操作
                [self hide];
            });
            
        }else {
            
            self.timeout ++;
        }
    });
    dispatch_resume(timer);
}

+ (void)hideAnimationStyle
{
    YIAnimationHUD *hud = [YIAnimationHUD sharedInstance];
    
    if (hud.isAnimation) {
        //正在显示中。。。
        //关闭动画
        hud.timeout = hud.maximumTime;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        
        [self createUI];
        
    }
    return self;
}

- (void)createUI {
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (UIView *)centerView
{
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_centerView];
        
        _centerView.layer.cornerRadius = 5;
    }
    return _centerView;
}

//菊花
- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        [self.centerView addSubview:_indicatorView];
    }
    return _indicatorView;
}

//图片帧
- (UIImageView *)pictureHeart
{
    if (!_pictureHeart) {
        _pictureHeart = [[UIImageView alloc] init];
        _pictureHeart.animationImages = [NSArray hj_imagesWithLocalGif:@"LoadingFood_Gif" expectSize:CGSizeMake(gifSize.height, gifSize.height)];
        _pictureHeart.contentMode = UIViewContentModeScaleAspectFit;
        _pictureHeart.animationRepeatCount = 0;
    }
    return _pictureHeart;
}

//gif 动画
- (UIImageView *)lottieHGif
{
    if (!_lottieHGif) {
        _lottieHGif = [[UIImageView alloc] init];
        _lottieHGif.animationImages = [NSArray hj_imagesWithLocalGif:@"LoadingFood_Gif" expectSize:CGSizeMake(gifSize.height, gifSize.height)];
        _lottieHGif.contentMode = UIViewContentModeScaleAspectFit;
        _lottieHGif.animationRepeatCount = 0;
    }
    return _lottieHGif;
}

//json动画
- (LOTAnimationView *)lottieHeart
{
    if (!_lottieHeart) {
        //获取文件地址
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"bundle"];
        _lottieHeart = [LOTAnimationView animationNamed:@"LoadingFood_Json" inBundle:[NSBundle bundleWithPath:plistPath]];
        _lottieHeart.contentMode = UIViewContentModeScaleAspectFit;
        _lottieHeart.loopAnimation = YES;
    }
    return _lottieHeart;
}

//闪动动画 - 模仿今日头条
- (YIFlashMoudule *)flashMoudule
{
    if (!_flashMoudule) {
        _flashMoudule = [[YIFlashMoudule alloc] initWithFrame:CGRectMake(0, 0, flashSize.width, flashSize.height)];
    }
    return _flashMoudule;
}



- (void)setStyle:(YIAnimationHUDStyle)style
{
    _style = style;
}

- (void)show
{
//    [YIWindow addSubview:self];

    //只适合这个框架方法
    [[YIManager getCurrentVC].view addSubview:self];
    
    [self setFrame:CGRectMake(0, 0, YIScreen_Width, YIScreen_Height - ([YIManager isThatSeletedVC]?YIBottom_Height:0))];

    self.hidden = NO;

    switch (_style) {
        case YIAnimationHUDStyleDefault:
            //菊花
            [self showAnimationHUDDefault];
            break;
        case YIAnimationHUDStyleFrameAnimation:
            //帧动画
            [self showAnimationHUDFrameAnimation];
            break;
        case YIAnimationHUDStyleGIF:
            //gif
            [self showAnimationHUDGIF];
            break;
        case YIAnimationHUDStyleJSONAnimation:
            //json动画
            [self showAnimationHUDJSONAnimation];
            break;
        case YIAnimationHUDStyleFlashAnimation:
            //闪动 模仿今日头条
            [self showAnimationHUDFlashAnimation];
            break;
        
        default:
            break;
    }
}

- (void)hide
{
    self.timeout = 0;
    
    switch (_style) {
        case YIAnimationHUDStyleDefault:
            //菊花
            [self hideAnimationHUDDefault];
            break;
        case YIAnimationHUDStyleFrameAnimation:
            //帧动画
            [self hideAnimationHUDFrameAnimation];
            break;
        case YIAnimationHUDStyleGIF:
            //gif
            [self hideAnimationHUDGIF];
            break;
        case YIAnimationHUDStyleJSONAnimation:
            //json动画
            [self hideAnimationHUDJSONAnimation];
            break;
        case YIAnimationHUDStyleFlashAnimation:
            //闪动 模仿今日头条
            [self hideAnimationHUDFlashAnimation];
            break;
        
        default:
            break;
    }
}

#pragma mark -----------------  菊花 ------------------
- (void)showAnimationHUDDefault
{
    //菊花开动
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.centerView);
    }];
    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(indiSize);
    }];
    
    YIViewShadow(self.centerView, [UIColor blackColor], 0, -1.0f, 0.3, 5);
    [self.indicatorView startAnimating];
}

- (void)hideAnimationHUDDefault
{
    //菊花停止
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];
    [self.indicatorView removeFromSuperview];
    self.indicatorView = nil;
    
    [self centerInit];
}

#pragma mark -----------------  帧动画 ------------------
- (void)showAnimationHUDFrameAnimation
{
    self.pictureHeart.frame = CGRectMake((gifSize.width-gifSize.height)/2, 0, gifSize.height, gifSize.height);
    [self.centerView addSubview:self.pictureHeart];
    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(gifSize);
    }];
    self.pictureHeart.hidden = NO;
       
    YIViewShadow(_centerView, [UIColor clearColor], 0, 0, 0, 0);
    [self.pictureHeart startAnimating];
}
- (void)hideAnimationHUDFrameAnimation
{
    [self.pictureHeart stopAnimating];
    self.pictureHeart.hidden = YES;
    self.pictureHeart.frame = CGRectMake(0, 0, 0, 0);
    
    [self.pictureHeart removeAllSubviews];
    [self.pictureHeart removeFromSuperview];
    self.pictureHeart = nil;
    
    [self centerInit];
}
#pragma mark -----------------  gif动画 ------------------
- (void)showAnimationHUDGIF
{
    self.lottieHGif.frame = CGRectMake((gifSize.width-gifSize.height)/2, 0, gifSize.height, gifSize.height);
    [self.centerView addSubview:self.lottieHGif];
    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(gifSize);
    }];
    self.lottieHGif.hidden = NO;
       
    YIViewShadow(_centerView, [UIColor clearColor], 0, 0, 0, 0);
    [self.lottieHGif startAnimating];
}
- (void)hideAnimationHUDGIF
{
    [self.lottieHGif stopAnimating];
    self.lottieHGif.hidden = YES;
    self.lottieHGif.frame = CGRectMake(0, 0, 0, 0);
    
    [self.lottieHGif removeAllSubviews];
    [self.lottieHGif removeFromSuperview];
    self.lottieHGif = nil;
    
    [self centerInit];
}
#pragma mark -----------------  json动画 ------------------
- (void)showAnimationHUDJSONAnimation
{
    self.lottieHeart.frame = CGRectMake((jsonSize.width-jsonSize.height)/2, 0, jsonSize.height, jsonSize.height);
    [self.centerView addSubview:self.lottieHeart];
    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(jsonSize);
    }];
    self.lottieHeart.hidden = NO;
    
    YIViewShadow(_centerView, [UIColor clearColor], 0, 0, 0, 0);
    [self.lottieHeart play];
}
- (void)hideAnimationHUDJSONAnimation
{
    [self.lottieHeart stop];
    self.lottieHeart.hidden = YES;
    self.lottieHeart.frame = CGRectMake(0, 0, 0, 0);
    
    [self.lottieHeart removeAllSubviews];
    [self.lottieHeart removeFromSuperview];
    self.lottieHeart = nil;
    
    [self centerInit];
}
#pragma mark -----------------  闪动 模仿今日头条动画 ------------------
- (void)showAnimationHUDFlashAnimation
{
    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(flashSize);
    }];
    [self.centerView addSubview:self.flashMoudule];
    self.flashMoudule.hidden = NO;
    self.flashMoudule.frame = CGRectMake(0, 0, flashSize.width, flashSize.height);
    
    YIViewShadow(_centerView, [UIColor clearColor], 0, 0, 0, 0);
    
    [self.flashMoudule startAnimation];
}
- (void)hideAnimationHUDFlashAnimation
{
    [self.flashMoudule stopAnimation];
    self.flashMoudule.hidden = YES;
    self.flashMoudule.frame = CGRectMake(0, 0, 0, 0);
    
    [self.flashMoudule removeAllSubviews];
    [self.flashMoudule removeFromSuperview];
    self.flashMoudule = nil;
    
    [self centerInit];
}



- (void)centerInit
{
    [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    self.timeout = 0;
    self.isAnimation = NO;
    self.hidden = YES;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.enable) {
        //YES 不允许交互
        return;
    }
    //点击事件 -----
    UITouch *touch = touches.anyObject;
    
    CGPoint pt = [touch locationInView:self];
    
    if (CGRectContainsPoint(CGRectMake(0, YIStatus_Height, 60, 44), pt)) {
        if (![YIManager isThatSeletedVC]) {
            [YIAnimationHUD hideAnimationStyle];
        }
        [YIManager popVC];
    }
}


@end
