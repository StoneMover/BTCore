//
//  BTCoreConfig.h
//  live
//
//  Created by stonemover on 2019/5/9.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTCoreConfig : NSObject

//获取请求状态中的提示信息
@property (nonatomic, copy) NSString *  (^netInfoBlock) (NSDictionary * _Nullable dict);

//获取请求内容中的数据
@property (nonatomic, copy) NSDictionary *  (^netDataBlock) (NSDictionary * _Nullable dict);

//获取请求结果的状态码，网络请求成功后
@property (nonatomic, copy) NSInteger  (^netCodeBlock) (NSDictionary * _Nullable dict);

//获取请求内容中的数组结构体
@property (nonatomic, copy) NSArray *  (^netDataArrayBlock) (NSDictionary * _Nullable dict);

//网络请求状态是否成功
@property (nonatomic, copy) BOOL  (^netSuccessBlock) (NSDictionary * _Nullable dict);

//默认的请求参数
@property (nonatomic, copy) NSDictionary * (^netDefaultDictBlock)(void);

//需要去掉导航器左右间距的约束回调
@property (nonatomic, copy) BOOL (^navItemPaddingBlock)(NSLayoutConstraint * constraint);

//请求返回内容的过滤器，可以做一些请求状态的全局逻辑处理，success和fail回调都会用此接口，比如账号冻结，如果想继续往下执行则返回YES
@property (nonatomic, copy) BOOL (^netFillterBlock)(NSObject * obj);


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

/*
 当网络请求到该数组中包含的code码的时候会发送相应的通知，通知名称BTCoreCodeNotification
 使用netFillterBlock自己处理
 */
@property (nonatomic, strong) NSArray * arrayNetCodeNotification DEPRECATED_ATTRIBUTE;

//是否打印请求数据
@property (nonatomic, assign) BOOL isLogHttpParameters;

#pragma mark 导航器通用配置
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

//导航器默认分割线颜色
@property (nonatomic, strong) UIColor * defaultNavLineColor;

//默认的vc背景色
@property (nonatomic, strong) UIColor * defaultVCBgColor;

+ (instancetype)share;

@end


NS_ASSUME_NONNULL_END
