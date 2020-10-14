//
//  YIBaseView.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/23.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIBaseView.h"

@implementation YIBaseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)reloadUI{}
- (void)addDelegate:(id)toView{}

- (void)dealloc
{
    YILog(@"dealloc ------ 成功");
}

@end
