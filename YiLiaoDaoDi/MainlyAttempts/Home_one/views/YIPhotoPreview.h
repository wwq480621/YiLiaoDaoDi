//
//  YIPhotoPreview.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIBaseView.h"
#import "YIPhotoView.h"
#import "YIPhotoMode.h"

NS_ASSUME_NONNULL_BEGIN



@interface YIPhotoPreview : YIBaseView

@property (nonatomic, readwrite, assign) int current;
@property (nonatomic, readwrite, assign) int selectedCurrent;

@property (nonatomic, readwrite, assign) YIPhotoViewStyle style;

+ (YIPhotoPreview *)photoPreviewWithArray:(NSArray<YIPhotoMode *> *)array;
+ (YIPhotoPreview *)photoPreviewWithArray:(NSArray<YIPhotoMode *> *)array style:(YIPhotoViewStyle)style;

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
