//
//  UIView+Utils.m
//  Borrowed from Three20
//
//  Copyright (c) 2013 iOS. No rights reserved.
//

#import "UIView+Utils.h"

#import <objc/runtime.h>

static char kDTActionHandlerTapBlockKey;
static char kDTActionHandlerTapGestureKey;
static char kDTActionHandlerLongPressBlockKey;
static char kDTActionHandlerLongPressGestureKey;

@implementation UIView (Utils)


- (UIViewController*)viewController
{
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


- (void)fadeToShow
{
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.5];
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transition setType:@"fade"];
    [self.layer addAnimation:transition forKey:nil];
}

- (void)pushAnimationTime:(CGFloat)animationTime subType:(NSString *)subType
{
    CATransition *transition = [CATransition animation];
    
    transition.duration = animationTime;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    transition.type = kCATransitionPush;
    
    transition.subtype = subType;
    
    [self.layer addAnimation:transition forKey:nil];
}

- (CGFloat)category_left
{
    return self.frame.origin.x;
}



- (void)setCategory_left:(CGFloat)category_left
{
    CGRect frame = self.frame;
    frame.origin.x = category_left;
    self.frame = frame;
}



- (CGFloat)category_top
{
    return self.frame.origin.y;
}



- (void)setCategory_top:(CGFloat)category_top{
    CGRect frame = self.frame;
    frame.origin.y = category_top;
    self.frame = frame;
}



- (CGFloat)category_right {
    return self.frame.origin.x + self.frame.size.width;
}



- (void)setCategory_right:(CGFloat)category_right {
    CGRect frame = self.frame;
    frame.origin.x = category_right - frame.size.width;
    self.frame = frame;
}



- (CGFloat)category_bottom {
    return self.frame.origin.y + self.frame.size.height;
}



- (void)setCategory_bottom:(CGFloat)category_bottom{
    CGRect frame = self.frame;
    frame.origin.y = category_bottom - frame.size.height;
    self.frame = frame;
}



- (CGFloat)category_centerX {
    return self.center.x;
}



- (void)setCategory_centerX:(CGFloat)category_centerX {
    self.center = CGPointMake(category_centerX, self.center.y);
}



- (CGFloat)category_centerY {
    return self.center.y;
}



- (void)setCategory_centerY:(CGFloat)category_centerY {
    self.center = CGPointMake(self.center.x, category_centerY);
}



- (CGFloat)category_width {
    return self.frame.size.width;
}



- (void)setCategory_width:(CGFloat)category_width{
    CGRect frame = self.frame;
    frame.size.width = category_width;
    self.frame = frame;
}



- (CGFloat)category_height {
    return self.frame.size.height;
}



- (void)setCategory_height:(CGFloat)category_height
{
    CGRect frame = self.frame;
    frame.size.height = category_height;
    self.frame = frame;
}



- (CGFloat)screenX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.category_left;
    }
    return x;
}



- (CGFloat)screenY {
    CGFloat y = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        y += view.category_top;
    }
    return y;
}



- (CGFloat)screenViewX {
    CGFloat x = 0.0f;
    for (UIView* view = self; view; view = view.superview) {
        x += view.category_left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}



- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.category_top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}



- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.category_width, self.category_height);
}



- (CGPoint)origin {
    return self.frame.origin;
}



- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}



- (CGSize)category_size
{
    return self.frame.size;
}



- (void)setCategory_size:(CGSize)category_size {
    CGRect frame = self.frame;
    frame.size = category_size;
    self.frame = frame;
}



- (CGFloat)orientationWidth {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.category_height : self.category_width;
}



- (CGFloat)orientationHeight {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.category_width : self.category_height;
}



- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}



- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}



- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}



- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0.0f, y = 0.0f;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.category_left;
        y += view.category_top;
    }
    return CGPointMake(x, y);
}


- (void)setTapActionWithBlock:(void (^)(void))block
{
	UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    
	if (!gesture)
	{
		gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
		[self addGestureRecognizer:gesture];
		objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
	}
    
	objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized)
	{
		void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        
		if (action)
		{
			action();
		}
	}
}

- (void)setLongPressActionWithBlock:(void (^)(void))block
{
	UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerLongPressGestureKey);
    
	if (!gesture)
	{
		gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForLongPressGesture:)];
		[self addGestureRecognizer:gesture];
		objc_setAssociatedObject(self, &kDTActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
	}
    
	objc_setAssociatedObject(self, &kDTActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForLongPressGesture:(UITapGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerLongPressBlockKey);
        
		if (action)
		{
			action();
		}
	}
}

@end
