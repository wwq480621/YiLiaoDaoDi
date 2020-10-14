//
//  YITextLocationView.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/25.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YITextLocationView.h"

@implementation YITextLocationView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setDataSource:(NSArray<YIAipOcrMode *> *)dataSource
{
    _dataSource = dataSource;
    
    if (self.dataSource.count > 0) {
        [self addWithLayer];
    }
}

- (void)addWithLayer
{
    for (YIAipOcrMode *ocrmode in self.dataSource) {
        [self addItemObjct:ocrmode];
    }
}

- (void)addItemObjct:(YIAipOcrMode *)ocrMode
{
    CALayer *layer = [CALayer layer];
    CGRect frame = CGRectMake(ocrMode.location.left, ocrMode.location.top, ocrMode.location.width, ocrMode.location.height);
    layer.frame = [[YIHomeManager sharedInstance] rectWithContratsFrame:frame toViewFrame:self.frame toImageSize:[YIHomeManager sharedInstance].contrastImage.size];
    
    if (ocrMode.thereAre) {
        layer.borderColor = [UIColor yellowColor].CGColor;
    }else {
        layer.borderColor = [UIColor redColor].CGColor;
    }
    
    layer.borderWidth = 0.4f;
    [self.layer addSublayer:layer];
    
    [self.items addObject:layer];
}

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray new];
    }
    return _items;
}

@end
