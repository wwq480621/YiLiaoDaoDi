//
//  UIView+YIGestap.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/24.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "UIView+YIGestap.h"
#import <objc/runtime.h>

static char kActionAddGestureBlockTapKey;
static char kActionAddGestureTapGestureKey;

static char kActionAddGestureBlockLongKey;
static char kActionAddGestureLongTapGestureKey;

@implementation UIView (YIGestap)

- (void)addTapGestureBlock:(gestureBlock)block {
    
    UITapGestureRecognizer *tapGest = objc_getAssociatedObject(self, &kActionAddGestureTapGestureKey);
    if (!tapGest) {
        tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerActionTapGesture:)];
        [self addGestureRecognizer:tapGest];
        objc_setAssociatedObject(self, &kActionAddGestureTapGestureKey, tapGest, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionAddGestureBlockTapKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handlerActionTapGesture:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized) {
        gestureBlock gestBlock = objc_getAssociatedObject(self, &kActionAddGestureBlockTapKey);
        if (gestBlock) {
            gestBlock(sender);
        }
    }
}

- (void)addLongTapGestureBlock:(gestureBlock)block {
    UILongPressGestureRecognizer *longGest = objc_getAssociatedObject(self, &kActionAddGestureLongTapGestureKey);
    if (!longGest) {
        longGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlerActionLongGesture:)];
        [self addGestureRecognizer:longGest];
        
        objc_setAssociatedObject(self, &kActionAddGestureLongTapGestureKey, longGest, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kActionAddGestureBlockLongKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handlerActionLongGesture:(UIGestureRecognizer *)sender
{
    gestureBlock block = objc_getAssociatedObject(self, &kActionAddGestureBlockLongKey);
    
    if (block) {
        block(sender);
    }
}

@end
