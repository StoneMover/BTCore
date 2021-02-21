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
- (UIBarButtonItem*)bt_createItemStr:(NSString*)title
                            color:(UIColor*)color
                             font:(UIFont*)font
                           target:(nullable id)target
                           action:(nullable SEL)action;

- (UIBarButtonItem*)bt_createItemStr:(NSString*)title
                           target:(nullable id)target
                           action:(nullable SEL)action;

- (UIBarButtonItem*)bt_createItemStr:(NSString*)title
                           action:(nullable SEL)action;

- (UIBarButtonItem*)bt_createItemImg:(UIImage*)img
                           action:(nullable SEL)action;

- (UIBarButtonItem*)bt_createItemImg:(UIImage*)img
                           target:(nullable id)target
                           action:(nullable SEL)action;

#pragma mark title、leftItem、rightItem初始化
- (void)bt_initTitle:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
- (void)bt_initTitle:(NSString*)title color:(UIColor*)color;
- (void)bt_initTitle:(NSString*)title;

- (UIBarButtonItem*)bt_initRightBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
- (UIBarButtonItem*)bt_initRightBarStr:(NSString*)title color:(UIColor*)color;
- (UIBarButtonItem*)bt_initRightBarStr:(NSString*)title;
- (UIBarButtonItem*)bt_initRightBarImg:(UIImage*)img;
- (void)bt_rightBarClick;

- (UIBarButtonItem*)bt_initLeftBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
- (UIBarButtonItem*)bt_initLeftBarStr:(NSString*)title color:(UIColor*)color;
- (UIBarButtonItem*)bt_initLeftBarStr:(NSString*)title;
- (UIBarButtonItem*)bt_initLeftBarImg:(UIImage*)img;
- (void)bt_leftBarClick;

#pragma mark 多个item的自定义view初始化
//在item上生成2个或者多个按钮的时候使用该方法
- (NSArray<UIView*>*)bt_initCustomeItem:(NavItemType)type str:(NSArray<NSString*>*)strs;
- (NSArray<UIView*>*)bt_initCustomeItem:(NavItemType)type img:(NSArray<UIImage*>*)imgs;
- (NSArray<UIView*>*)bt_initCustomeItem:(NavItemType)type views:(NSArray<UIView*>*)views;

//获取相关的配置
- (CGSize)bt_customeItemSize:(NavItemType)type index:(NSInteger)index;
- (CGFloat)bt_customePadding:(NavItemType)type index:(NSInteger)index;

//仅限自定义字符串样式的回调
- (UIColor*)bt_customeStrColor:(NavItemType)type index:(NSInteger)index;
- (UIFont*)bt_customeFont:(NavItemType)type index:(NSInteger)index;

//点击后的事件
- (void)bt_customeItemClick:(NavItemType)type index:(NSInteger)index;


#pragma mark 其它相关快捷方法
//设置item左右间距为默认间距，默认为5，可以在BTCoreConfig的navItemPadding设置所有默认值
- (void)bt_setItemPaddingDefault;

//设置item左右间距
- (void)bt_setItemPadding:(CGFloat)padding;

//设置导航器背景透明
- (void)bt_setNavTrans;

//隐藏导航器分割线
- (void)bt_setNavLineHide;

//设置导航器分割线颜色
- (void)bt_setNavLineColor:(UIColor*)color;

- (void)bt_setNavLineColor:(UIColor*)color height:(CGFloat)height;

//如果想单独调整某一个vc的item的左右间距，实现该方法
- (CGFloat)bt_NavItemPadding:(NavItemType)type;

@end


typedef void(^BTDialogBlock)(NSInteger index);


@interface UIViewController (BTDialog)

//快速创建btnDict字典类型,@{"title":"要显示的内容","color":颜色对象,"font":字体对象,"style":展示的样式}
- (NSDictionary*)bt_createBtnDict:(NSString*)title color:(UIColor*)color;

- (NSDictionary*)bt_createBtnDict:(NSString*)title color:(UIColor*)color style:(UIAlertActionStyle)style;

//创建一个alertController
- (UIAlertController*_Nonnull)bt_createAlert:(NSString*_Nullable)title
                                         msg:(NSString*_Nullable)msg
                                      action:(NSArray*_Nullable)action
                                       style:(UIAlertControllerStyle)style;

//创建action
- (UIAlertAction*_Nonnull)bt_action:(NSString*_Nullable)str
                              style:(UIAlertActionStyle)style
                            handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

- (UIAlertAction*_Nonnull)bt_action:(NSString*_Nullable)str
                              style:(UIAlertActionStyle)style
                              color:(UIColor*)color
                            handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

//显示对话框,如果是两个选项,第一个使用取消类型,第二个使用默认类型,如果大于两个选项最后一个会被默认为取消类型
- (UIAlertController*_Nonnull)bt_showAlert:(NSString*_Nonnull)title
                                       msg:(NSString*_Nullable)msg
                                      btns:(NSArray*_Nullable)btns
                                     block:(BTDialogBlock _Nullable )block;

//传入自己的配置项,btnDicts字典类型数组，使用bt_createBtnDict创建
- (UIAlertController*_Nonnull)bt_showAlert:(NSString*_Nonnull)title
                                       msg:(NSString*_Nullable)msg
                                  btnDicts:(NSArray*_Nullable)btnDicts
                                     block:(BTDialogBlock _Nullable )block;




//显示确定取消类型
- (UIAlertController*_Nonnull)bt_showAlertDefault:(NSString*_Nullable)title
                                              msg:(NSString*_Nullable)msg
                                            block:(BTDialogBlock _Nullable)block;

//显示底部弹框,最后一个为取消类型
- (UIAlertController*_Nonnull)bt_showActionSheet:(NSString*_Nullable)title
                                             msg:(NSString*_Nullable)msg
                                            btns:(NSArray*_Nullable)btns
                                           block:(BTDialogBlock _Nullable )block;

//传入自己的配置项,btnDicts字典类型数组，使用bt_createBtnDict创建
- (UIAlertController*_Nonnull)bt_showActionSheet:(NSString*_Nullable)title
                                             msg:(NSString*_Nullable)msg
                                        btnDicts:(NSArray*_Nullable)btnDicts
                                           block:(BTDialogBlock _Nullable )block;



//显示编辑框类型
- (UIAlertController*_Nonnull)bt_showAlertEdit:(NSString*_Nullable)title
                                  defaultValue:(NSString*_Nullable)value
                                   placeHolder:(NSString*_Nullable)placeHolder
                                         block:(void(^_Nullable)(NSString * _Nullable result))block;

//显示编辑框类型,btnDicts为取消、确定的配置，btnDicts中可以为字符串或者字典，会根据类型自动判断
- (UIAlertController*_Nonnull)bt_showAlertEdit:(NSString*_Nullable)title
                                  defaultValue:(NSString*_Nullable)value
                                   placeHolder:(NSString*_Nullable)placeHolder
                                      btnDicts:(NSArray*_Nullable)btnDicts
                                         block:(void(^_Nullable)(NSString * _Nullable result))block;


@end

NS_ASSUME_NONNULL_END
