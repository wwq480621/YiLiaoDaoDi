//
//  YITableView.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/23.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YITableView.h"

@interface YITableView ()

@end

@implementation YITableView

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        [_tableView setTableFooterView:[UIView new]];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    
    return _tableView;
}

- (void)reloadUI
{
    [self.tableView reloadData];
}

- (void)addDelegate:(id)toView
{
    
}

@end
