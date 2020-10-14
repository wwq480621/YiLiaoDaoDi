//
//  YIFlashMoudle.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/23.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIFlashMoudule.h"

@interface YIFlashMoudule ()
@property (nonatomic, readwrite, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *txtLab;
@property (nonatomic, readwrite, strong) CAGradientLayer *gradientLayer;
@end


@implementation YIFlashMoudule

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViewUI];
    }
    return self;
}

- (void)createViewUI
{
    //WithFrame:CGRectMake(0, 100, 320, 70)
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, self.category_width - 24, self.category_height - 24)];
    lb.text = @"享用美食中";
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont boldSystemFontOfSize:25];
    lb.adjustsFontSizeToFitWidth = YES;
    [self addSubview:lb];
    
    self.txtLab = lb;
    
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame = CGRectMake(0, 0, self.category_width, self.category_height);
    colorLayer.position = self.center;
    [self.layer addSublayer:colorLayer];
    
    colorLayer.colors = @[(__bridge id)[UIColor lightGrayColor].CGColor,(__bridge id)[UIColor grayColor].CGColor,(__bridge id)[UIColor lightGrayColor].CGColor];
    colorLayer.locations = @[@(- 0.2),@(- 0.1),@(0)];
    colorLayer.startPoint = CGPointMake(0, 0.6);
    colorLayer.endPoint = CGPointMake(1, 0.4);
    colorLayer.mask = lb.layer;
    
    self.gradientLayer = colorLayer;
}

- (void)sendMessageWithNumber:(CAGradientLayer *)colorLayer
{
    CABasicAnimation *fadeA = [CABasicAnimation animationWithKeyPath:@"locations"];
    fadeA.fromValue = @[@(-0.2), @(-0.1),@(0)] ;
    fadeA.toValue = @[@(1.0),@(1.1),@(1.2)] ;
    fadeA.duration = 2;
    [colorLayer addAnimation:fadeA forKey:nil];
}

- (void)startAnimation
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            CABasicAnimation *fadeA = [CABasicAnimation animationWithKeyPath:@"locations"];
            fadeA.fromValue = @[@(-0.2), @(-0.1),@(0)] ;
            fadeA.toValue = @[@(1.0),@(1.1),@(1.2)] ;
            fadeA.duration = 2 ;
            [self.gradientLayer addAnimation:fadeA forKey:nil];
        }];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }else {
            
        //创建签名对象的时候不是使用NSMethodSignature这个类创建，而是方法属于谁就用谁来创建
        NSMethodSignature*signature = [YIFlashMoudule instanceMethodSignatureForSelector:@selector(sendMessageWithNumber:)];
        //1、创建NSInvocation对象
        NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = self;
        //invocation中的方法必须和签名中的方法一致。
        invocation.selector = @selector(sendMessageWithNumber:);
        
        [invocation setArgument:&_gradientLayer atIndex:2];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 invocation:invocation repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopAnimation
{
    [self.timer invalidate];
    self.timer = nil;
    [self.gradientLayer removeAnimationForKey:@"locations"];
}

- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
