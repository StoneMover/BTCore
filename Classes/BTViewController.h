//
//  BTViewController.h
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BTHelp/BTUtils.h>
#import <BTHelp/UIColor+BTColor.h>
#import <BTLoading/UIViewController+BTLoading.h>
#import <BTLoading/BTToast.h>
#import <BTLoading/BTProgress.h>
#import <BTWidgetView/UIView+BTViewTool.h>
#import <RTRootNavigationController/RTRootNavigationController.h>
#import "BTCoreConfig.h"
#import "BTPageLoadView.h"
#import "BTNavigationView.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^BTVcSuccessBlock)(NSObject * _Nullable obj);

typedef NS_ENUM(NSInteger,BTWebViewLoadingType) {
    BTWebViewLoadingDefault = 0,
    BTWebViewLoadingProgress
};


@interface BTViewController : UIViewController

//是否在触摸结束后关闭键盘，默认true
@property (nonatomic, assign) BOOL isTouceViewEndCloseKeyBoard;

//界面调用viewWillAppear的次数
@property (nonatomic, assign) NSInteger viewWillAppearIndex;

//界面调用viewDidAppear的次数
@property (nonatomic, assign) NSInteger viewDidAppearIndex;

//前后页面的简单回调
@property (nonatomic, copy, nullable) BTVcSuccessBlock blockSuccess;

//自定义的导航器头部
@property (nonatomic, strong) BTNavigationView * btNavView;

//当vc完全出现后的第一次调用，只会调用一次，用在一些需要在界面完全显示后才需要进行初始化的情况
- (void)viewDidAppearFirst;

//获取数据的方法
- (void)getData;

//重新加载网络数据
- (void)bt_loadingReload;

@end

@interface BTNavigationController : RTRootNavigationController

@end

@class WKWebView;

@interface BTWebViewController : BTViewController

@property (nonatomic, strong) NSString * url;

//导航器初始title
@property (nonatomic, strong, nullable) NSString * webTitle;

//导航器标题是否跟随网页变化
@property (nonatomic, assign) BOOL isTitleFollowWeb;

//加载中样式
@property (nonatomic, assign) BTWebViewLoadingType loadingType;

//进度条加载样式情况下的进度条颜色,默认红色
@property (nonatomic, strong, nullable) UIColor * progressViewColor;

//关闭按钮,设置了该值后,将会出现返回和关闭两个按钮,返回按钮可以返回上一个网页,关闭按钮直接退出webview
@property (nonatomic, strong, nullable) UIImage * closeImg;

//导航器分割线颜色，默认238
@property (nonatomic, strong) UIColor * webNavLineColor;

//添加到js 的方法,在初始化之前设置,back为返回方法，组件自己设备，不允许重名，重名后将收不到回调并直接退出界面
@property (nonatomic, strong) NSArray * jsFunctionArray;

//js方法调用回调
@property (copy, nonatomic) void (^jsFunctionBlock)(NSString * name,NSString * body);

//NSURLRequest设置回调
@property (copy, nonatomic) void (^requestSetBlock)(NSURLRequest * _Nullable  request);

//webview初始化完成
@property (nonatomic, copy) void (^btWebInitFinish)(WKWebView * webView);

//webView加载成功
@property (nonatomic, copy) void (^btWebLoadSuccessBlock)(WKWebView * webView);

@end


@interface BTPageLoadViewController : BTViewController<BTPageLoadViewDelegate>

@property (nonatomic, strong, readonly) BTPageLoadView * pageLoadView;

//从statusbar 开始布局适用于顶部透明的vc
- (void)setLayoutFromStatusBar;

@end


typedef NS_ENUM(NSInteger,NavItemType) {
    NavItemTypeLeft = 0,
    NavItemTypeRight
};

@interface UIViewController (BTNavSet)

#pragma mark item创建
- (UIBarButtonItem*)createItemStr:(NSString*)title
                            color:(UIColor*)color
                             font:(UIFont*)font
                           target:(nullable id)target
                           action:(nullable SEL)action;

- (UIBarButtonItem*)createItemStr:(NSString*)title
                           target:(nullable id)target
                           action:(nullable SEL)action;

- (UIBarButtonItem*)createItemStr:(NSString*)title
                           action:(nullable SEL)action;

- (UIBarButtonItem*)createItemImg:(UIImage*)img
                           action:(nullable SEL)action;

- (UIBarButtonItem*)createItemImg:(UIImage*)img
                           target:(nullable id)target
                           action:(nullable SEL)action;

#pragma mark title、leftItem、rightItem初始化
- (void)initTitle:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
- (void)initTitle:(NSString*)title color:(UIColor*)color;
- (void)initTitle:(NSString*)title;

- (void)initRightBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
- (void)initRightBarStr:(NSString*)title color:(UIColor*)color;
- (void)initRightBarStr:(NSString*)title;
- (void)initRightBarImg:(UIImage*)img;
- (void)rightBarClick;

- (void)initLeftBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
- (void)initLeftBarStr:(NSString*)title color:(UIColor*)color;
- (void)initLeftBarStr:(NSString*)title;
- (void)initLeftBarImg:(UIImage*)img;
- (void)leftBarClick;

#pragma mark 多个item的自定义view初始化
//在item上生成2个或者多个按钮的时候使用该方法
- (void)initCustomeItem:(NavItemType)type str:(NSArray<NSString*>*)strs;
- (void)initCustomeItem:(NavItemType)type img:(NSArray<UIImage*>*)imgs;

//获取相关的配置
- (CGSize)customeItemSize:(NavItemType)type;
- (CGFloat)customePadding:(NavItemType)type;
- (UIColor*)customeStrColor:(NavItemType)type;
- (UIFont*)customeFont:(NavItemType)type;

//点击后的事件
- (void)customeItemClick:(NavItemType)type index:(NSInteger)index;


#pragma mark 其它相关快捷方法
- (void)setItemPaddingDefault;

- (void)setItemPadding:(CGFloat)padding;

- (void)setNavTrans;

- (void)setNavLineHide;

- (void)setNavLineColor:(UIColor*)color;

- (void)setNavLineColor:(UIColor*)color height:(CGFloat)height;

- (CGFloat)bt_NavItemPadding:(NavItemType)type;

@end


typedef void(^BTDialogBlock)(NSInteger index);


@interface UIViewController (BTDialog)

//创建一个alertController
- (UIAlertController*_Nonnull)createAlert:(NSString*_Nullable)title
                                      msg:(NSString*_Nullable)msg
                                   action:(NSArray*_Nullable)action
                                    style:(UIAlertControllerStyle)style;

//创建action
- (UIAlertAction*_Nonnull)action:(NSString*_Nullable)str
                           style:(UIAlertActionStyle)style
                         handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

//显示对话框,如果是两个选项,第一个使用取消类型,第二个使用默认类型,如果大于两个选项最后一个会被默认为取消类型
- (UIAlertController*_Nonnull)showAlert:(NSString*_Nonnull)title
                                    msg:(NSString*_Nullable)msg
                                   btns:(NSArray*_Nullable)btns
                                  block:(BTDialogBlock _Nullable )block;


//显示确定取消类型
- (UIAlertController*_Nonnull)showAlertDefault:(NSString*_Nullable)title
                                           msg:(NSString*_Nullable)msg
                                         block:(BTDialogBlock _Nullable)block;

//显示底部弹框,最后一个为取消类型
- (UIAlertController*_Nonnull)showActionSheet:(NSString*_Nullable)title
                                          msg:(NSString*_Nullable)msg
                                         btns:(NSArray*_Nullable)btns
                                        block:(BTDialogBlock _Nullable )block;

//显示编辑框类型
- (UIAlertController*_Nonnull)showAlertEdit:(NSString*_Nullable)title
                               defaultValue:(NSString*_Nullable)value
                                placeHolder:(NSString*_Nullable)placeHolder
                                      block:(void(^_Nullable)(NSString * _Nullable result))block;


@end

NS_ASSUME_NONNULL_END
