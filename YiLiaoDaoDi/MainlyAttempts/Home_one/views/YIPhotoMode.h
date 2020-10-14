//
//  YIPhotoMode.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YIPhotoMode : NSObject

@property (nonatomic, readwrite, strong) UIImage *normalImage;
@property (nonatomic, readwrite, strong) NSString *imgUrl;

@property (nonatomic, strong) UIView *originalView; //原视图

@end

NS_ASSUME_NONNULL_END
