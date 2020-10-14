//
//  NSArray+YIGIFImages.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/25.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "NSArray+YIGIFImages.h"
#import <ImageIO/ImageIO.h>

@implementation NSArray (YIGIFImages)

+ (NSArray *)hj_imagesWithLocalGif:(NSString *)gifName{
    
    return [self hj_imagesWithLocalGif:gifName expectSize:CGSizeZero];
}


+ (NSArray *)hj_imagesWithLocalGif:(NSString *)gifName expectSize:(CGSize)size{
    
    BOOL needResize = (size.height!=0 && size.width!=0);
    
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:gifName withExtension:@"gif"];
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    for (size_t i = 0; i< gifCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        if (needResize) {
            image = [self imageByScalingAndCroppingForSize:size withImage:image];
        }
        [frames addObject:image];
        CGImageRelease(imageRef);
    }
    return frames;
}


+ (NSArray *)hj_imagesWithLocalArrayNames:(NSString *)name
{
    return [self hj_imagesWithLocalArrayNames:name expectSize:CGSizeZero];
}


+ (NSArray *)hj_imagesWithLocalArrayNames:(NSString *)name expectSize:(CGSize)size
{
    NSMutableArray *images = [NSMutableArray array];
    int count = 0;
    for (int i=0; i< 100; i++) {
        
        UIImage *image = [UIImage imageNamed:YIStringFormat(@"%@%d",name,i)];
        if (image) {
            [images addObject:[self imageByScalingAndCroppingForSize:size withImage:image]];
        }else {
            count ++;
            if (count > 5) {
                if (images.count > 0) {
                    return images;
                }else {
                    return [self hj_imagesWithLocalArrayField:name expectSize:size];
                }
            }
            continue;
        }
    }
    return images;
}

+ (NSArray *)hj_imagesWithLocalArrayField:(NSString *)field
{
    return [self hj_imagesWithLocalArrayField:field expectSize:CGSizeZero];
}

+ (NSArray *)hj_imagesWithLocalArrayField:(NSString *)field expectSize:(CGSize)size
{
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i=0; i< 100; i++) {
        
        NSString *plist_png = [[NSBundle mainBundle] pathForResource:YIStringFormat(@"%@%d",field,i) ofType:@"png"];
        NSString *plist_jpg = [[NSBundle mainBundle] pathForResource:YIStringFormat(@"%@%d",field,i) ofType:@"jpg"];
        
        if (!YI_IS_STR(plist_png)) {
            UIImage *image = [UIImage imageWithContentsOfFile:plist_png];
            [images addObject:[self imageByScalingAndCroppingForSize:size withImage:image]];
        }
        else if (!YI_IS_STR(plist_jpg)) {
            UIImage *image = [UIImage imageWithContentsOfFile:plist_jpg];
            [images addObject:[self imageByScalingAndCroppingForSize:size withImage:image]];
        }else {
            //没有图片资源
            return images;
        }
    }
    
    return images;
}


//图片压缩到指定大小
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
