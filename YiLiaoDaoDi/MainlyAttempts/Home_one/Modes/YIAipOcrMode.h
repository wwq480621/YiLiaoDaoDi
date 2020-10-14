//
//  YIAipOcrMode.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/24.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YIAipOcrLocationMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface YIAipOcrMode : NSObject

@property (nonatomic, readwrite, strong) NSString *words;
@property (nonatomic, readwrite, strong) YIAipOcrLocationMode *location;

@property (nonatomic, readwrite, assign) BOOL thereAre;

@end

NS_ASSUME_NONNULL_END
