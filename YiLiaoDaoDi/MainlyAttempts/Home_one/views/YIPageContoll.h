//
//  YIPageContoll.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YIPageContoll : YIBaseView

@property (nonatomic, readwrite, assign) int maxcount;

@property (nonatomic, readwrite, assign) int selectedCurrent;

@end

NS_ASSUME_NONNULL_END
