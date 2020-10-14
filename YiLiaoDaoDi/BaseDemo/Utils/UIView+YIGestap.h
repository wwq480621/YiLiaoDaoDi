//
//  UIView+YIGestap.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/24.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^gestureBlock)(UIGestureRecognizer *sender);

@interface UIView (YIGestap)

- (void)addTapGestureBlock:(gestureBlock)block;

- (void)addLongTapGestureBlock:(gestureBlock)block;

@end

NS_ASSUME_NONNULL_END
