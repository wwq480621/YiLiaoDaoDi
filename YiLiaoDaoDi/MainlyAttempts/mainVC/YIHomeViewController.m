//
//  YIHomeViewController.m
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/23.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import "YIHomeViewController.h"
#import "YITableView.h"
#import "YIAlertBox.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <GPUImage/GPUImage.h>
#import "YIPhotoPreview.h"
#import "YIAipMode.h"
#import <objc/runtime.h>

@class YIAnimationHUD;

static NSString *const kTemplateDiagramSubmission = @"kTemplateDiagramSubmission";
// 默认的识别成功的回调
typedef void (^_successHandler)(id);
// 默认的识别失败的回调
typedef void (^_failHandler)(NSError *);

@interface YIHomeViewController () <UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>

@property (nonatomic, readwrite, copy) _successHandler success;
@property (nonatomic, readwrite, copy) _failHandler failt;

@property (nonatomic, readwrite, strong) UIImage *deteimage;
@property (nonatomic, strong) YITableView *mainView;
@property (nonatomic, readwrite, strong) NSMutableArray *dataSource;
@property (nonatomic, readwrite, strong) NSString *funClass;
@end

@implementation YIHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.naviTitle = @"美食资讯";
    
    [[AipOcrService shardService] authWithAK:@"Mt10zaGMfSMABwvFKe0fabqc" andSK:@"BgKfczzvO9yqmoiODTEOW2ppMYFRpaRM"];
    
    [self configCallback];
    // Do any additional setup after loading the view.
}


- (UIView *)custemMainView
{
    _mainView = [[YITableView alloc] init];
    
    return _mainView;
}

- (void)setupUseInterface
{
    //初始化
    _mainView.tableView.delegate = self;
    _mainView.tableView.dataSource = self;
    //选择 ---
    [self.dataSource addObject:@[@"模板图提交",@"TemplateDiagramSubmission"]];
    [self.dataSource addObject:@[@"报表识别 --- 与模板图对比",@"StatementsIdentify"]];
//    [self.dataSource addObject:@[@"重复报表提交 - 改动区域提醒",@"DuplicateReportSubmission"]];
    [self.dataSource addObject:@[@"价格计算 - 暂无实现汇率",@"ThePriceCalculation"]];
    
    [_mainView reloadUI];
}

#pragma mark --------------- tableView Delegate -------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTemplateDiagramSubmission];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kTemplateDiagramSubmission];
    }
    cell.textLabel.text = self.dataSource[indexPath.row][0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
//    SEL funSel = NSSelectorFromString(self.dataSource[indexPath.row][1]);
//    if (funSel) {
//        #pragma clang diagnostic push
//        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        [self performSelector:funSel];
//        #pragma clang diagnostic pop
//    }
    
    _funClass = self.dataSource[indexPath.row][1];
    
    if ([_funClass isEqualToString:@"TemplateDiagramSubmission"] || [_funClass isEqualToString:@"StatementsIdentify"]) {
        [self TemplateDiagramSubmission];
    }
}

- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _success = ^(id result){
        YILog(@"%@", result);
        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        
        YIAipMode *mode = [YIAipMode mj_objectWithKeyValues:result];
        if ([weakSelf.funClass isEqualToString:@"StatementsIdentify"]) {
            [YIHomeManager sharedInstance].contrasts = mode.words_result;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf openPhotoContrast];
            });
            
        }else {
            [YIHomeManager sharedInstance].preViews = mode.words_result;
        }
        [YIAnimationHUD hideAnimationStyle];
        
        if(mode.words_result){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                }
            }
        }else{
            [message appendFormat:@"%@", result];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }];
    };
    
    _failt = ^(NSError *error){
        NSLog(@"%@", error);
        [YIAnimationHUD hideAnimationStyle];
        
        [weakSelf detecText];
    };
}

//精确版 上限
- (void)detecText
{
    [YIAnimationHUD showAnimationStyle:YIAnimationHUDStyleJSONAnimation];
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
    [[AipOcrService shardService] detectTextFromImage:self.deteimage
                                                  withOptions:options
                                               successHandler:self.success
                                                  failHandler:self.failt];
}


- (void)TemplateDiagramSubmission
{
    //预览 - 拍照 - 相册 - 。。。 后续加URL下载 ---
//    UIAlertController
    YIAlertBox *box = [YIAlertBox alertBox];
    
    WeakSelf(self);
    YIAction *ylaction = [YIAction actionWithText:@"预览" actionState:1 complectionHandler:^(NSString * _Nonnull text, NSInteger current) {
        StrongSelf(self);
        [self openPhotoPreView];
    }];
    
    YIAction *pzaction = [YIAction actionWithText:@"拍照" actionState:0 complectionHandler:^(NSString * _Nonnull text, NSInteger current) {
        StrongSelf(self);
        [self openTakingPicture];
    }];
    
    YIAction *xcaction = [YIAction actionWithText:@"相册" actionState:0 complectionHandler:^(NSString * _Nonnull text, NSInteger current) {
        StrongSelf(self);
        [self openPhotoPicker];
    }];
    
    if ([self.funClass isEqualToString:@"StatementsIdentify"]) {
        if ([YIHomeManager sharedInstance].contrastImage) {
            [box addAction:ylaction];
        }
    }else {
        if ([YIHomeManager sharedInstance].previewImage) {
            [box addAction:ylaction];
        }
    }
    
    [box addActions:@[pzaction,xcaction]];
    [box show];
}

- (void)openPhotoContrast
{
    YIPhotoMode *mode = [YIPhotoMode new];
    mode.normalImage = [YIHomeManager sharedInstance].contrastImage;
    
    YIPhotoPreview *photo = [YIPhotoPreview photoPreviewWithArray:@[mode] style:(YIPhotoViewStyleContrast)];
    [photo show];
}

- (void)openPhotoPreView
{
    if ([self.funClass isEqualToString:@"StatementsIdentify"]) {
        [self openPhotoContrast];
        return;
    }
    YIPhotoMode *mode = [YIPhotoMode new];
    mode.normalImage = [YIHomeManager sharedInstance].previewImage;
    
    YIPhotoPreview *photo = [YIPhotoPreview photoPreviewWithArray:@[mode]];
    [photo show];
}


- (void)openTakingPicture
{
    //拍照
    WeakSelf(self);
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        StrongSelf(self);
        if ([self.funClass isEqualToString:@"StatementsIdentify"]) {
            [YIHomeManager sharedInstance].contrastImage = image;
        }else {
            [YIHomeManager sharedInstance].previewImage = image;
        }
        self.deteimage = image;
        [YIAnimationHUD showAnimationStyle:YIAnimationHUDStyleJSONAnimation];
        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextAccurateFromImage:image
                                                      withOptions:options
                                                   successHandler:self.success
                                                      failHandler:self.failt];
        
    }];
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (void)openPhotoPicker
{
    //相册
    TZImagePickerController *imagePiker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:1 delegate:self pushPhotoPickerVc:YES];
    imagePiker.allowTakeVideo = NO;
    imagePiker.allowPickingVideo = NO;
    imagePiker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    imagePiker.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        //选择照片
        if (photos.count > 0) {
            
            if ([self.funClass isEqualToString:@"StatementsIdentify"]) {
                [YIHomeManager sharedInstance].contrastImage = photos[0];
            }else {
                [YIHomeManager sharedInstance].previewImage = photos[0];
            }
            [YIAnimationHUD showAnimationStyle:YIAnimationHUDStyleJSONAnimation];
            self.deteimage = photos[0];
            NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
            [[AipOcrService shardService] detectTextAccurateFromImage:photos[0] withOptions:options successHandler:self.success failHandler:self.failt];
        }
    };
    
    [[YIManager getCurrentVC] presentViewController:imagePiker animated:YES completion:nil];
    
}



- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

@end
