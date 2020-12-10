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

/*
 请求返回内容的过滤器，可以做一些请求状态的全局逻辑处理，success和fail回调都会用此接口，比如账号冻结，如果想继续往下执行则返回YES
 */
@property (nonatomic, copy) BOOL (^netFillterBlock)(NSObject * _Nullable obj);


/*
 处理NSError对象的错误信息获取
 这里特指code不为200的时候，后面可能还有后端返回的json信息，实现此方法通过error对象获取字典返回需要显示的错误信息
 */
@property (nonatomic, copy) NSString * (^netErrorInfoFillterBlock)(NSError * error);


/*
 获取请求结果的状态码，网络请求成功后返回的http 状态为200
 这里特指已经返回200的情况后，获取字典中的类似status或者success的字段进行相关逻辑
 */
@property (nonatomic, copy) NSInteger  (^netCodeBlock) (NSDictionary * _Nullable dict);

/*
 网络请求状态是否成功，网络请求成功后返回的http 状态为200
 这里特指已经返回200的情况后,通过字典中的类似status或者success的字段进行业务逻辑判断的成功与否
 */
@property (nonatomic, copy) BOOL  (^netSuccessBlock) (NSDictionary * _Nullable dict);


/*
 获取请求状态中的提示信息,这里主要是针对返回http 状态 为200的字典信息错误，如果不为200需要取出后台的错误信息使用netErrorInfoFillterBlock
 如果当code不为200且获取的为字典对象同样可以调用该方法一同处理
 */
@property (nonatomic, copy) NSString *  (^netInfoBlock) (NSDictionary * _Nullable dict);



/*
 获取请求后返回的字典内容中的数据，一般为data字段，为防止字段不同可自行实现进行获取
 */
@property (nonatomic, copy) NSDictionary *  (^netDataBlock) (NSDictionary * _Nullable dict);



/*
 获取请求内容中的数组结构体
 专门针对数据列表返回的数据的特定字段获取，如果字段统一则实现该方法统一返回数组数据
 */
@property (nonatomic, copy) NSArray *  (^netDataArrayBlock) (NSDictionary * _Nullable dict);


/*
 
 默认的请求参数
 当你的请求需要携带默认参数的时候实现该方法
 */
@property (nonatomic, copy) NSDictionary * (^netDefaultDictBlock)(void);

/*
 如果需要去掉导航器左右间距的约束回调
 */
@property (nonatomic, copy) BOOL (^navItemPaddingBlock)(NSLayoutConstraint * constraint);


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


//分页数量大小参数名称
@property (nonatomic, strong) NSString * pageLoadSizeName;

//分页下标参数名称
@property (nonatomic, strong) NSString * pageLoadIndexName;

//继承于BTUserModel 的用户模型
@property (nonatomic, strong) Class userModelClass;


//BTUserMananger 初始化的时候注册的默认字典值
@property (nonatomic, strong) NSDictionary * userManDefaultDict;

/*
 当网络请求到该数组中包含的code码的时候会发送相应的通知，通知名称BTCoreCodeNotification
 使用netFillterBlock自己处理
 */
@property (nonatomic, strong) NSArray * arrayNetCodeNotification DEPRECATED_ATTRIBUTE;

//是否打印请求参数值
@property (nonatomic, assign) BOOL isLogHttpParameters;

//是否显示在logView中
@property (nonatomic, assign) BOOL  isShowLogView;

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

//是否开启系统日志功能
@property (nonatomic, assign) BOOL isOpenLog;

//导航器返回的按钮距离左边的间距,默认5
@property (nonatomic, assign) CGFloat navItemPadding;

+ (instancetype)share;

@end


NS_ASSUME_NONNULL_END
