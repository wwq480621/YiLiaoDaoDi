//
//  YIUserObject.h
//  YiLiaoDaoDi
//
//  Created by MD101 on 2020/7/22.
//  Copyright © 2020 QiXia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YIUserObject : NSObject

@property (nonatomic, readwrite, strong) NSDictionary *userData;

@property (nonatomic, readwrite, strong) NSString *userName;
@property (nonatomic, readwrite, strong) NSNumber *userId;
@property (nonatomic, readwrite, strong) NSNumber *sex;
@property (nonatomic, readwrite, strong) NSNumber *age;
@property (nonatomic, readwrite, strong) NSNumber *telephone;
@property (nonatomic, readwrite, strong) NSString *passWord;

@property (nonatomic, readwrite, strong) NSString *vip;


@end

NS_ASSUME_NONNULL_END
