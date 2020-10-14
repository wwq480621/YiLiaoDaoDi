//
//  NSArray+YIGIFImages.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/25.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (YIGIFImages)

+ (NSArray *)hj_imagesWithLocalGif:(NSString *)gifName;

+ (NSArray *)hj_imagesWithLocalGif:(NSString *)gifName expectSize:(CGSize)size;

///assets 并兼容 查找本地库图片  name 为图片名字的前缀 -  图片名字的后缀拼接 0、1、2、3、4、5、6.....
+ (NSArray *)hj_imagesWithLocalArrayNames:(NSString *)name;
///assets 并兼容 查找本地库图片 name 为图片名字的前缀 -  图片名字的后缀拼接 0、1、2、3、4、5、6.....
+ (NSArray *)hj_imagesWithLocalArrayNames:(NSString *)name expectSize:(CGSize)size;

///查找本地库图片 name 为图片名字的前缀 -  图片名字的后缀拼接 0、1、2、3、4、5、6.....
+ (NSArray *)hj_imagesWithLocalArrayField:(NSString *)field;
///查找本地库图片 name 为图片名字的前缀 -  图片名字的后缀拼接 0、1、2、3、4、5、6.....
+ (NSArray *)hj_imagesWithLocalArrayField:(NSString *)field expectSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
