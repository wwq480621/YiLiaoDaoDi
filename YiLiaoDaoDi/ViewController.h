//
//  ViewController.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/6/29.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^block_o)(id Json,id obj);

@interface ViewController : UIViewController

@property (nonatomic, readwrite, copy) block_o block;

//单例
YI_SHARED_DEFINE(ViewController)

@end

