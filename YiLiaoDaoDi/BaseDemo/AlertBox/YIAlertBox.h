//
//  YIAlertBox.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/21.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIBaseView.h"
#import "YIAction.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^hideBox)(NSString *text, NSInteger rechargeRow);

@interface YIAlertBox : YIBaseView

@property (nonatomic, strong) UIView *mainView; //承载view

@property (nonatomic, strong) UIView *centerView;       //选择view
@property (nonatomic, strong) UIButton *cancelItem;       //底部取消

@property (nonatomic, readwrite, copy) hideBox handler;

@property (nonatomic, readwrite, assign) BOOL isShowBox;   //是否已经弹出

@property (nonatomic, readwrite, strong) NSMutableArray *dataSource;

+ (YIAlertBox *)alertBox;
- (void)addAction:(YIAction *)action;
- (void)addActions:(NSArray<YIAction *> *)array;

- (void)show;
- (void)hide;
- (void)hideBox:(void(^)(void))handler;


@end

NS_ASSUME_NONNULL_END
