//
//  YIAlertBox.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/21.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIAlertBox.h"

#define boxItemTag 1201

@interface YIAlertBox ()
@property (nonatomic, readwrite, strong) NSMutableArray *items;
@property (nonatomic, readwrite, assign) CGFloat boxcenterY;
@end

@implementation YIAlertBox

+ (YIAlertBox *)alertBox
{
    YIAlertBox *alert = [[YIAlertBox alloc] init];
    
    return alert;
}

- (void)addAction:(YIAction *)action
{
    UIButton *actionItem = [UIButton buttonWithType:(UIButtonTypeCustom)];
    actionItem.titleLabel.font = kTextFont(15);
    [actionItem setTitle:action.text forState:(UIControlStateNormal)];
    [actionItem setTitleColor:action.textColor forState:(UIControlStateNormal)];
    [actionItem setBackgroundColor:[UIColor whiteColor]];
    [actionItem addTarget:self action:@selector(actionAlertClick:) forControlEvents:(UIControlEventTouchUpInside)];
    actionItem.tag = boxItemTag + self.items.count;
    [self.centerView addSubview:actionItem];
    
    [actionItem mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.items.count == 0) {
            make.top.equalTo(self.centerView);
        }else {
            UIButton *old = self.items.lastObject;
            make.top.equalTo(old.mas_bottom).mas_offset(0.5);
        }
        make.left.right.equalTo(self.centerView);
        make.height.mas_equalTo(44);
    }];
    
    [self.dataSource addObject:action];
    [self.items addObject:actionItem];
    
    [self boxHeight];
}

//按钮事件 ---
- (void)actionAlertClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - boxItemTag;
    if (tag < 0 || tag >= self.dataSource.count) {
        return;
    }
    YIAction *action = [self.dataSource objectAtIndex:tag];
    if (action.complblock) {
        action.complblock(action.text, tag);
    }else {
        //实现另外的点击事件传递
        if (self.handler) {
            self.handler(action.text, tag);
        }
    }
    [self hide];
}

- (void)addActions:(NSArray<YIAction *> *)array
{
    for (YIAction *action in array) {
        [self addAction:action];
    }
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
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        [self setupdateConstraintUI];

    }
    return self;
}
- (void)setupdateConstraintUI
{
    [self addSubview:self.mainView];
    [self.mainView addSubview:self.centerView];
    [self.mainView addSubview:self.cancelItem];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(16);
        make.right.equalTo(self).mas_offset(-16);
        make.centerY.equalTo(self);
    }];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.mainView);
    }];
    
    [self.cancelItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_bottom).mas_offset(12);
        make.left.right.equalTo(self.mainView);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.mainView).mas_offset(-12);
    }];
    
}
- (void)initializeData
{
    //初始化
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    self.hidden = NO;
    
    self.mainView.transform = CGAffineTransformMakeRotation(0 *M_PI / 180.0);
    
    [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).mas_offset(YIScreen_Height/2);
    }];
    
    if (self.items.count > 0) {
        UIButton *item = self.items.lastObject;
        [item mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.centerView);
        }];
    }
    
    [self layoutIfNeeded];
}

- (UIView *)mainView
{
    if (!_mainView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        view.clipsToBounds = YES;
        
        _mainView = view;
    }
    return _mainView;
}
- (UIView *)centerView
{
    if (!_centerView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        
        _centerView = view;
    }
    return _centerView;
}
- (UIButton *)cancelItem
{
    if (!_cancelItem) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.titleLabel.font = kTextFontName(titleFontBold, 16);
        [button setTitle:@"取消" forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(hide) forControlEvents:(UIControlEventTouchUpInside)];
        _cancelItem = button;
    }
    return _cancelItem;
}

- (CGFloat)hideBoxHeight
{
    CGFloat height = self.items.count*44 + (self.items.count-1) + (68);
    return (YIScreen_Height/2 + height/2);
}
- (void)boxHeight
{
    CGFloat height = self.items.count*44 + (self.items.count-1) + (68);
    CGFloat boxmoblie = YIScreen_Height/2 - height/2;
    
    self.boxcenterY = boxmoblie;
}

- (void)show
{
    if (self.isShowBox) {
        
        return;
    }
    self.isShowBox = YES;

    [self initializeData];
    
//    [[YIManager getCurrentVC].view addSubview:self];
    [YIWindow addSubview:self];
    
    [self setFrame:CGRectMake(0, 0, YIScreen_Width, YIScreen_Height)];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).mas_offset(self.boxcenterY);
        }];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.mainView.transform = CGAffineTransformMakeRotation(0 *M_PI / 180.0);
        }];
    }];
}

- (void)hide
{
    [self hideBox:^{
        
    }];
}

- (void)hideBox:(void (^)(void))handler
{
    if (!self.isShowBox) {
        //没有弹出
        return;
    }
    self.isShowBox = NO;
    
    [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).mas_offset(([self hideBoxHeight]));
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
            
        } completion:^(BOOL finished) {
            self.hidden = YES;
            
            if (handler) {
                handler();
            }
        }];
    }];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view != self.mainView) {
        [self hide];
    }
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray new];
    }
    return _items;
}

@end
