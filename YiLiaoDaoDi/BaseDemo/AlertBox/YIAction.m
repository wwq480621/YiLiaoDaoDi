//
//  YIAction.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/21.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIAction.h"

@implementation YIAction

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textColor = [UIColor blackColor];
    }
    return self;
}

+ (YIAction *)actionWithText:(NSString *)text actionState:(NSInteger)state complectionHandler:(complcationBlock)handler
{
    YIAction *action = [YIAction actionWithText:text actionState:state];
    action.complblock = handler;
    return action;
}

+ (YIAction *)actionWithText:(NSString *)text actionState:(NSInteger)state
{
    YIAction *action = [[YIAction alloc] init];
    action.text = text;
    action.state = state;
    return action;
}

- (void)setState:(YIActionStyle)state
{
    if (state == YIActionStyleSelected) {
        self.textColor = [UIColor redColor];
    }
}




@end
