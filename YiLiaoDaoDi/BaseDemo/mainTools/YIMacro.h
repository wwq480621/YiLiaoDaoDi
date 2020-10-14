//
//  YIMacro.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#ifndef YIMacro_h
#define YIMacro_h

//----------------判断当前的iPhone设备/系统版本---------------
// 判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
// 判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

//----------------判断机型 根据尺寸---------------
// 判断是否为 iPhone 4/4S - 3.5 inch
#define iPhone4_4S [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 480.0f
// 判断是否为 iPhone 5/5SE - 4.0 inch
#define iPhone5_5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
// 判断是否为iPhone 6/6S/7/8 - 4.7 inch
#define iPhone6_6S [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
// 判断是否为iPhone 6Plus/6SPlus/7P/8P - 5.5 inch
#define iPhone6Plus_8Plus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f
// 判断是否为iPhoneX - 5.8 inch
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否为iPhoneXS - 5.8 inch
#define iPhoneXS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否为iPhoneXR - 6.1 inch
#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断是否为iPhoneXS MAX - 6.5 inch
#define iPhoneXSMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

//------------------------ 系统类 -------------
#define YIApplication  [UIApplication sharedApplication]
#define YIWindow [UIApplication sharedApplication].delegate.window    //keyWindow,push页面使用[g_window addSubView:];
#define YIAppDelegate  [UIApplication sharedApplication].delegate
#define YIUserDefaults  [NSUserDefaults standardUserDefaults]
#define YINotificationCenter [NSNotificationCenter defaultCenter]

//---------------- 设备状态栏高度 底部高度 -----------------
#define YIStatus_Height [[UIApplication sharedApplication] statusBarFrame].size.height
#define YINavation_Height 44.0f
#define YIScreen_Top (YIStatus_Height + YINavation_Height)
#define YIScreen_Width [UIScreen mainScreen].bounds.size.width
#define YIScreen_Height [UIScreen mainScreen].bounds.size.height
#define YIBottom_Height ((YIStatus_Height > 20 && YIStatus_Height != 40) ? 83 : 49)

//------------- app配置 ----------------
#define YI_appName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]  //app名
#define YI_appVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]   //app版本号


//---------------- app 方法简化 -------------------
#define YILocalStr(A) NSLocalizedString(A, nil);
#define YIRGBAColor(r, g, b, a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//设置字体
#define titleFontBold   @"Helvetica-Bold"
#define TextFont       @"Helvetica"
#define iconFont        @"iconfont"
#define kTextFont(s) [UIFont fontWithName:TextFont size:s]
#define kTextFontName(name,s) [UIFont fontWithName:name size:s]


//relese 不输出
#ifndef __OPTIMIZE__
//普通输出
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])

//输出
#define YILog(format,...)   do {                                                \
    fprintf(stderr, "<%s : 第%d行> %s\n",                                           \
    [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
    __LINE__, __func__);                                                          \
    (NSLog)((format), ##__VA_ARGS__);                                           \
    fprintf(stderr, "-------\n");                                               \
} while (0)

//字典输出
#define YIDictLog(format) if ([format isKindOfClass:[NSDictionary class]]) \
{\
    fprintf(stderr, "<%s : 第%d行> %s\n",                                           \
    [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
    __LINE__, __func__);                                                          \
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:format options:NSJSONWritingPrettyPrinted error:nil];\
    NSString *objString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];\
    fprintf(stderr, "<---NSDictionary : %s> \n", [objString UTF8String]); \
}\

#else
#define YILog(format,...) {}
#define YIDictLog(format) {}
#define NSLog(...) {}
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif


//字符串拼接
#define YIStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]


//颜色 hex
#define YICOLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]
//block 防循环持有
#define WeakSelf(type) __weak typeof(type) weak##type = type;
#define StrongSelf(type) __strong typeof(type) type = weak##type;

//主题色 淡绿色 --- 暂时
#define MainColor YICOLOR_WITH_HEX(0x8bd180)
//[UIColor colorWithRed:(147 / 255.0) green:(112 / 255.0) blue:(219 / 255.0) alpha:1.0] //主题色


//圆角 边框
#define YIViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]];

#define YIViewShadow(view,color,width,height,opacity,radius)    \
view.layer.shadowColor = color.CGColor;\
view.layer.shadowOffset = CGSizeMake(width,height);\
view.layer.shadowOpacity = opacity;\
view.layer.shadowRadius = radius;\

//alert
#define YIAlertShowTime(time,fmt,...)  {\
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:nil otherButtonTitles:nil]; [alert show];\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
    [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];\
});\
}

#define YIAlertShow(fmt,...) YIAlertShowTime(1.0,fmt,##__VA_ARGS__)

#define YIAlertVCShowTime(time,fmt,...) {\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:fmt, ##__VA_ARGS__] preferredStyle:(UIAlertControllerStyleAlert)];\
    [self presentViewController:alertVc animated:YES completion:nil];\
    \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
        [alertVc dismissViewControllerAnimated:YES completion:nil];\
    });\
});\
}

#define YIAlertVCShow(fmt,...) YIAlertVCShowTime(1.0,fmt,##__VA_ARGS__)


//block判空 不为空则传递值
#define YIBLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); }

/** 2.空值判断  YES为空 */
#define YI_IS_EMPTY_STR(_str)        (((_str) == nil) || ([(_str) isKindOfClass:[NSNull class]]) ||([(_str) isEqualToString:@""]))
#define YI_IS_EMPTY_ARR(_arr)        (((_arr) == nil) || ([(_arr) isKindOfClass:[NSNull class]]) ||([(_arr) count] ==0))
#define YI_IS_EMPTY_DICT(_dict)      (((_dict) == nil) || ([(_dict) isKindOfClass:[NSNull class]]) || ([[(_dict) allKeys] count] == 0))
#define YI_IS_EMPTY_IMAGE(_IMG)      (((_IMG) == nil) || ([(_IMG) isKindOfClass:[NSNull class]]))

//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//判断是否为字符串 数组 字典 number
#define YI_IS_STR(_str)     ([_str isKindOfClass:[NSString class]])
#define YI_IS_ARR(_str)     ([_str isKindOfClass:[NSArray class]])
#define YI_IS_DICT(_str)    ([_str isKindOfClass:[NSDictionary class]])
#define YI_IS_Num(_str)     ([_str isKindOfClass:[NSNumber class]])


/** 3.单例*/
//声明单例
#undef  YI_SHARED_DEFINE
#define YI_SHARED_DEFINE( __class ) \
+ (__class *)sharedInstance;
//实现单例
#undef  YI_SHARED_IMPLEMENT
#define YI_SHARED_IMPLEMENT( __class ) \
+ (__class *)sharedInstance \
{ \
static __class * __singleton__ = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
__singleton__ = [[__class alloc] init]; \
}); \
return __singleton__; \
}

// ----------- 5.获取当前语言 ------------
#define YICurrentLanguage ([[NSLocale preferredLanguages]objectAtIndex:0])

//--------------沙盒目录文件路径---------------
// 获取沙盒主目录路径
#define YISBPath_Home = NSHomeDirectory();
//获取沙盒 Document
#define YISBPath_Document [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Library
#define YISBPath_Library [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
//获取沙盒 Cache
#define YISBPath_Cache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
//获取temp
#define YISBPath_Temp NSTemporaryDirectory()

#endif /* YIMacro_h */
