//
//  YITextLocationView.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/25.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIBaseView.h"
#import "YIAipMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface YITextLocationView : YIBaseView

@property (nonatomic, readwrite, strong) NSArray<YIAipOcrMode *>  *dataSource;

@property (nonatomic, readwrite, strong) NSMutableArray *items;

@end

NS_ASSUME_NONNULL_END
