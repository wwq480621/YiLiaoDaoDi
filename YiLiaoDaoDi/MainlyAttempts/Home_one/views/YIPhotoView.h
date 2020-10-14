//
//  YIPhotoView.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/8/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIBaseView.h"

NS_ASSUME_NONNULL_BEGIN



@interface YIPhotoView : YIBaseView
//图片
@property (nonatomic, readwrite, strong) UIImage *image;
//网络图片 -
@property (nonatomic, readwrite, strong) NSString *imageURL;

@property (nonatomic, readwrite, assign) YIPhotoViewStyle style;
@property (nonatomic, readwrite, strong) YIImageView *photo;

@end

NS_ASSUME_NONNULL_END
