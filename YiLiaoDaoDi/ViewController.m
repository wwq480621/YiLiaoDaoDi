//
//  ViewController.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/6/29.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//实现单例
YI_SHARED_IMPLEMENT(ViewController)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = YIStringFormat(@"1%@",@"2");
    
    YILog(@"123 /r/n \r\n");
    YILog(@"123%@%@",@"456",str);
    YILog(@"%@",YIStringFormat(@"1%@",@"2"));
    NSLog(@"%@",YIStringFormat(@"1%@",@"2"));
    NSLog(@"123");
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = [self getLaunchImage];
    [self.view addSubview:imageView];
    
    NSArray *array = [NSArray arrayWithObjects:@"sd",@"bs",@"ys",@"qs", nil];
    YILog(@"%@",array);
    
    NSDictionary *obj = [NSDictionary dictionaryWithObjectsAndKeys:@"jg",@"nnm",@"ggk",@"name", nil];
    YIDictLog(obj);
    
    YIBLOCK_EXEC(self.block,@"123",@1)
    
    if (!YI_IS_EMPTY_STR(str)) {
        YILog(@"0909");
    }
    YILog(@"str %d -- arr %d -- obj %d",YI_IS_EMPTY_STR(str),YI_IS_EMPTY_ARR(array),YI_IS_EMPTY_DICT(obj));
    
    YIAlertVCShow(@"%@%@%@",@"需要经历",@"九九八十一难",@"才能有期待的收获");
    
    // Do any additional setup after loading the view.
}

/** 获取启动图片 获得LaunchImage中的启动图 */
- (UIImage *)getLaunchImage
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";                // 横屏请设置为 @"Landscape"
    UIImage *lauchImage = nil;
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
            
            break;
        }
    }
    
    return lauchImage;
}

@end
