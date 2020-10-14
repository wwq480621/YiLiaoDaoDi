//
//  YIBaseViewController.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIBaseViewController.h"
#import <MJRefresh.h>

@interface YIBaseViewController ()

@property (nonatomic, strong) UILabel *naviLabel;

@property (nonatomic, readwrite, strong) NSMutableArray<UIButton *> *leftItems;

@property (nonatomic, readwrite, strong) NSMutableArray<UIButton *> *rightItems;

@property (nonatomic, strong) UIImageView *navBottomLine; //导航底部黑线

@end


@implementation YIBaseViewController

- (void)dealloc
{
    YILog(@"结束  super class --- %s --- 第%d行 dealloc",__func__,__LINE__);
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        YILog(@"开始 super class %s --- 第%d行 --- init",__func__,__LINE__);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navi];
    [self.view addSubview:self.rootView];
    
    [_navi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        
        if ([self isNavigationHidden]) {
            make.height.mas_equalTo(YIScreen_Top);
        }else{
            make.height.mas_equalTo(0);
        }
    }];
    [_rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navi.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-[self isCustenMainViewBottomHeight]);
    }];
    
    [self setupUseInterface];
    [self requestRefreshDataSource];
    [self showNaviLine:NO];
    // Do any additional setup after loading the view.
}


- (UIView *)custemMainView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

- (void)setupUseInterface {}
- (void)requestRefreshDataSource {}
- (void)requestMoreRefreshDataSource {}
//退出按钮
- (void)showNavigationBackItem
{
    [self.navi addSubview:self.backBtn];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.navi);
    }];
}
//右侧按钮
- (void)showNavigationRightImageName:(NSString *)imageName setTitle:(NSString *)title setTitleColor:(UIColor *)color setSelect:(SEL)selected
{
    [self.rightItems removeAllObjects];
    
    UIButton *evaluationBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    if (imageName != nil && imageName.length > 0) {
        [evaluationBtn setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    }
    if (title != nil && title.length > 0) {
        [evaluationBtn setTitle:title forState:(UIControlStateNormal)];
    }
    if (!color) {
        color = [UIColor grayColor];
    }
    
    if (selected) {
        [evaluationBtn addTarget:self action:selected forControlEvents:UIControlEventTouchUpInside];
    }
    evaluationBtn.titleLabel.font = kTextFont(15);
    [evaluationBtn setTitleColor:color forState:UIControlStateNormal];
    
    [self.navi addSubview:evaluationBtn];
    
    [evaluationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.navi);
    }];
    
    [self.rightItems addObject:evaluationBtn];
}
//左侧按钮
- (void)showNavigationLeftImageName:(NSString *)imageName setTitle:(NSString *)title setTitleColor:(UIColor *)color setSelect:(SEL)selected
{
    [self removeLeftItem];
    [self.leftItems removeAllObjects];
    
    UIButton *evaluationBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    if (imageName != nil && imageName.length > 0) {
        [evaluationBtn setImage:[UIImage imageNamed:imageName] forState:(UIControlStateNormal)];
    }
    if (title != nil && title.length > 0) {
        [evaluationBtn setTitle:title forState:(UIControlStateNormal)];
    }
    if (!color) {
        color = [UIColor grayColor];
    }
    
    if (selected) {
        [evaluationBtn addTarget:self action:selected forControlEvents:UIControlEventTouchUpInside];
    }
    evaluationBtn.titleLabel.font = kTextFont(15);
    [evaluationBtn setTitleColor:color forState:UIControlStateNormal];
    
    [self.navi addSubview:evaluationBtn];
    
    [evaluationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_backBtn) {
            make.left.mas_equalTo(_backBtn.mas_right).mas_offset(0);
        }else {
            make.left.mas_equalTo(0);
        }
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.navi);
    }];
    
    [self.leftItems addObject:evaluationBtn];
}

- (void)removeLeftItem
{
    //清除左侧按钮
    for (UIButton *item in self.leftItems) {
        [item removeFromSuperview];
    }
}

- (void)showNaviLine:(BOOL)bol
{
    self.navBottomLine.hidden = bol;
}
//退出
- (void)navigationBackEvent
{
    [self actionQuit];
}

//退出
-(void)actionQuit {
    //取消当前vc的网络加载
//    [g_server stopConnection:self];
    //关闭键盘
    [YIWindow endEditing:YES];
    
    [YIManager popVC];
}



- (UIView *)navi
{
    if (!_navi) {
        _navi = [[UIView alloc] init];
        _navi.backgroundColor = MainColor;
    }
    return _navi;
}

- (UILabel *)naviLabel
{
    if (!_naviLabel) {
        UILabel *titleLab = [[UILabel alloc]init];
        titleLab.font = kTextFontName(titleFontBold, 18);
        [self.navi addSubview:titleLab];
        titleLab.textAlignment = NSTextAlignmentCenter;
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(YIStatus_Height);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(44);
            make.centerX.equalTo(self.navi);
        }];
        
        _naviLabel = titleLab;

    }
    return _naviLabel;
}


- (UIButton *)backBtn
{
    if (!_backBtn) {
        UIButton *evaluationBtn = [[UIButton alloc]init];
        
        [evaluationBtn setImage:[UIImage imageNamed:@"title_white_back"] forState:(UIControlStateNormal)];
        evaluationBtn.selected = NO;
        [evaluationBtn setTitleColor:YIRGBAColor(92, 100, 179,1) forState:UIControlStateNormal];
        [evaluationBtn addTarget:self action:@selector(navigationBackEvent) forControlEvents:UIControlEventTouchUpInside];
        
        _backBtn = evaluationBtn;

    }
    return _backBtn;
}

- (UIImageView *)navBottomLine
{
    if (_navBottomLine == nil)
    {
        _navBottomLine = [[UIImageView alloc] init];
        _navBottomLine.hidden = YES;
        _navBottomLine.backgroundColor = YICOLOR_WITH_HEX(0xC6C6C6);
        
        [self.navi addSubview:_navBottomLine];
        
        [_navBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.navi);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    return _navBottomLine;
}

- (UIView *)rootView
{
    if (!_rootView) {
        _rootView = [self custemMainView];
    }
    return _rootView;
}

//是否显示navi 默认yes
- (BOOL)isNavigationHidden
{
    return YES;
}
- (CGFloat)isCustenMainViewBottomHeight
{
    return 0;
}

- (void)setNaviTitle:(NSString *)naviTitle
{
    self.naviLabel.text = naviTitle;
}
- (void)setNaviTitleColor:(UIColor *)naviTitleColor
{
    self.naviLabel.textColor = naviTitleColor;
}
- (void)setNaviTitleFont:(UIFont *)naviTitleFont
{
    self.naviLabel.font = naviTitleFont;
}

- (BOOL)isMore:(NSInteger)count isSize:(NSInteger)p_size
{
    NSInteger c = count%p_size;
    if (c > 0) {
        //有余数 - 说明后面没有数据了
        return NO;
    }
    //没有余数 继续加载
    return YES;
}

- (NSMutableArray<UIButton *> *)leftItems
{
    if (!_leftItems) {
        _leftItems = [NSMutableArray new];
    }
    return _leftItems;
}

- (NSMutableArray<UIButton *> *)rightItems
{
    if (!_rightItems) {
        _rightItems = [NSMutableArray new];
    }
    return _rightItems;
}


@end
