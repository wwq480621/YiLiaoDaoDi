//
//  YIAction.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/21.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^complcationBlock)(NSString *text,NSInteger current);

typedef NS_ENUM(NSInteger,YIActionStyle) {
    YIActionStyleDefault        =   0,      //默认 ---- 黑色
    YIActionStyleSelected       =   1,      //设置为已选中状态 --- redColor
};

@interface YIAction : NSObject

@property (nonatomic, readwrite, strong) NSString *text;
@property (nonatomic, readwrite, assign) YIActionStyle state;
@property (nonatomic, readwrite, copy) complcationBlock complblock;
//默认使用state设置 ----- 自定义就设置textColor
@property (nonatomic, readwrite, strong) UIColor *textColor;

//不使用action的block回调事件
+ (YIAction *)actionWithText:(NSString *)text actionState:(NSInteger)state;
//使用action的block回调事件 --- 优先级高于alertBoxblock的回调事件
+ (YIAction *)actionWithText:(NSString *)text actionState:(NSInteger)state complectionHandler:(complcationBlock)handler;


@end

NS_ASSUME_NONNULL_END
