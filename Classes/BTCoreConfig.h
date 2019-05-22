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


//pageLoad 获取列表的key，默认为list
@property (nonatomic, strong) NSString * keyPageList;


//默认的主题颜色,默认为红色
@property (nonatomic, strong) UIColor * mainColor;

//action文字颜色，用于弹出默认action的文字颜色
@property (nonatomic, strong) UIColor * actionColor;

//默认取消颜色,用于弹框中的取消action
@property (nonatomic, strong) UIColor * actionCancelColor;


//分页加载的起始页，默认的是1
@property (nonatomic, assign) NSInteger pageLoadStartPage;

//分页加载的默认每页数据，默认的是每页20条数据
@property (nonatomic, assign) NSInteger pageLoadSizePage;

//继承于BTUserModel 的用户模型
@property (nonatomic, strong) Class userModelClass;


//BTUserMananger 初始化的时候注册的默认字典值
@property (nonatomic, strong) NSDictionary * userManDefaultDict;

+ (instancetype)share;

@end


