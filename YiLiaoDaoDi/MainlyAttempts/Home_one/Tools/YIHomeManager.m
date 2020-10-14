//
//  YIHomeManager.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/21.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIHomeManager.h"
#import "YIAipMode.h"

@implementation YIHomeManager

YI_SHARED_IMPLEMENT(YIHomeManager)

- (void)setContrasts:(NSArray *)contrasts
{
    if (YI_IS_EMPTY_IMAGE(_previewImage)) {
        YIAlertShow(@"缺少预览图片");
        return;
    }
    if (YI_IS_EMPTY_ARR(_preViews)) {
        YIAlertShow(@"缺少预览图片的坐标,请重新上传预览图片");
        return;
    }
    if (YI_IS_EMPTY_IMAGE(_contrastImage)) {
        YIAlertShow(@"缺少对比图片");
        return;
    }
    _contrasts = contrasts;
    
    [self startPickingFights];
}

- (void)startPickingFights
{
    if (YI_IS_EMPTY_IMAGE(_previewImage)) {
        YIAlertShow(@"缺少预览图片");
        return;
    }
    if (YI_IS_EMPTY_ARR(_preViews)) {
        YIAlertShow(@"缺少预览图片的坐标,请重新上传预览图片");
        return;
    }
    if (YI_IS_EMPTY_IMAGE(_contrastImage)) {
        YIAlertShow(@"缺少对比图片");
        return;
    }
    if (YI_IS_EMPTY_ARR(_contrasts)) {
        YIAlertShow(@"缺少对比图片的坐标,请重新上传对比图片");
        return;
    }
    
    for (NSInteger i=0; i<_preViews.count; i++) {
        YIAipOcrMode *premode = _preViews[i];
        
        for (NSInteger j=0; j<_contrasts.count; j++) {
            YIAipOcrMode *conmode = _contrasts[i];
            
            if ([conmode.words isEqualToString:premode.words] || [conmode.words containsString:@"?"] || [conmode.words containsString:@"？"]) {
                conmode.thereAre = YES;
            }
        }
    }
    
}

- (CGRect)rectWithPreViewImageFrame:(CGRect)rect
{
    CGFloat maxWidth = YIScreen_Width;
    CGFloat sacle = maxWidth/rect.size.width;
    CGFloat maxHeight = sacle * rect.size.height;
    
    CGFloat left = sacle * rect.origin.x;
    CGFloat top = sacle * rect.origin.y;
    
    //返回的是当前比例位置 ----
    return CGRectMake(left, top, maxWidth, maxHeight);
}

- (CGRect)rectWithContratsFrame:(CGRect)rect toViewFrame:(CGRect)toFrame toImageSize:(CGSize)imgSize
{
    CGFloat scale_w = toFrame.size.width/imgSize.width;
    CGFloat scale_h = toFrame.size.height/imgSize.height;
    
    CGFloat width = rect.size.width*scale_w;
    CGFloat height = rect.size.height*scale_h;
    
    CGFloat left = rect.origin.x*scale_w;
    CGFloat top = rect.origin.y*scale_h;
    
    return CGRectMake(left, top, width, height);
}

@end
