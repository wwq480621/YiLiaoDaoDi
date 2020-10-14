//
//  YIAipMode.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/24.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YIAipOcrMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface YIAipMode : NSObject

@property (nonatomic, readwrite, strong) NSNumber *words_result_num;
@property (nonatomic, readwrite, strong) NSNumber *direction;
@property (nonatomic, readwrite, strong) NSNumber *log_id;
@property (nonatomic, readwrite, strong) NSArray *words_result;

@end

NS_ASSUME_NONNULL_END
