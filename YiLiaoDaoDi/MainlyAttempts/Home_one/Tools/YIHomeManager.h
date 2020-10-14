//
//  YIHomeManager.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/21.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YIHomeManager : NSObject

YI_SHARED_DEFINE(YIHomeManager)

@property (nonatomic, readwrite, strong) UIImage *previewImage;   //选中的预览图片
@property (nonatomic, readwrite, strong) NSArray *preViews;       //选中的预览图片的坐标数据

@property (nonatomic, readwrite, strong) UIImage *contrastImage;    //需要对比的图片
@property (nonatomic, readwrite, strong) NSArray *contrasts;        //需要对比的坐标数据

@property (nonatomic, readwrite, strong) NSMutableArray *differences;       //对比之后的坐标数据

//找茬游戏      //previewImage --- preViews ---- contrasts---- 必要数据
- (void)startPickingFights;

//frame转换 --- 根据YIScreen_Width的大小来转换 输入image上文字的坐标位置，按比例转换为屏幕的坐标位置
- (CGRect)rectWithPreViewImageFrame:(CGRect)rect;
//textloaction
- (CGRect)rectWithContratsFrame:(CGRect)rect toViewFrame:(CGRect)toFrame toImageSize:(CGSize)imgSize;

@end

NS_ASSUME_NONNULL_END
