//
//  BTCoreConfig.h
//  live
//
//  Created by stonemover on 2019/5/9.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface BTCoreConfig : NSObject

//请求返回后的key名称设置
@property (nonatomic, strong) NSString * netKeyInfo;

@property (nonatomic, strong) NSString * netKeyData;

@property (nonatomic, strong) NSString * netKeyCode;

@property (nonatomic, assign) NSInteger netSuccessCode;

//请求的root url和img url
@property (nonatomic, strong) NSString * rootUrl;

@property (nonatomic, strong) NSString * imgRootUrl;

//发送请求的默认参数名称设置
@property (nonatomic, strong) NSString * keyOs;

@property (nonatomic, strong) NSString * keyVersion;

@property (nonatomic, strong) NSString * keyOsVersion;

@property (nonatomic, strong) NSString * keyUid;

@property (nonatomic, strong) NSString * keyToken;


//pageLoad 相关参数key
@property (nonatomic, strong) NSString * keyPageList;


//默认的主题颜色,默认为红色
@property (nonatomic, strong) UIColor * mainColor;


+ (instancetype)share;

@end

