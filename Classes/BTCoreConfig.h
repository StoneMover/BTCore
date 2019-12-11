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

@property (nonatomic, copy) NSString *  (^netInfoBlock) (NSDictionary * dict);

@property (nonatomic, copy) NSDictionary *  (^netDataBlock) (NSDictionary * dict);

@property (nonatomic, copy) NSInteger  (^netCodeBlock) (NSDictionary * dict);

@property (nonatomic, copy) NSArray *  (^netDataArrayBlock) (NSDictionary * dict);

@property (nonatomic, copy) BOOL  (^netSuccessBlock) (NSDictionary * dict);

@property (nonatomic, copy) NSDictionary * (^defaultHttpDict)(void);


//请求的root url和img url
@property (nonatomic, strong) NSString * rootUrl;

@property (nonatomic, strong) NSString * imgRootUrl;



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

//当网络请求到该数组中包含的code码的时候会发送相应的通知，通知名称BTCoreCodeNotification
@property (nonatomic, strong) NSArray * arrayNetCodeNotification;

//是否打印请求数据
@property (nonatomic, assign) BOOL isLogHttpParameters;

//导航器标题默认文字字体
@property (nonatomic, strong) UIFont * defaultNavTitleFont;

//导航器标题默认文字颜色
@property (nonatomic, strong) UIColor * defaultNavTitleColor;

//导航器leftBarItem标题默认字体
@property (nonatomic, strong) UIFont * defaultNavLeftBarItemFont;

//导航器leftBarItem标题默认颜色
@property (nonatomic, strong) UIColor * defaultNavLeftBarItemColor;

//导航器rightBarItem标题默认字体
@property (nonatomic, strong) UIFont * defaultNavRightBarItemFont;

//导航器rightBarItem标题默认颜色
@property (nonatomic, strong) UIColor * defaultNavRightBarItemColor;

+ (instancetype)share;

@end


