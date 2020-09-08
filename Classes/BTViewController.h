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
#import "UIViewController+BTDialog.h"
#import "UIViewController+BTNavSet.h"

#import "BTPageLoadView.h"


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

//当vc完全出现后的第一次调用，只会调用一次，用在一些需要在界面完全显示后才需要进行初始化的情况
- (void)viewDidAppearFirst;

//获取数据的方法
- (void)getData;

//重新加载网络数据
- (void)bt_loadingReload;

@end

@interface BTNavigationController : RTRootNavigationController

@end



@interface BTWebViewController : BTViewController

@property (nonatomic, strong) NSString * url;

//导航器初始title
@property (nonatomic, strong) NSString * webTitle;

//导航器标题是否跟随网页变化
@property (nonatomic, assign) BOOL isTitleFollowWeb;

//加载中样式
@property (nonatomic, assign) BTWebViewLoadingType loadingType;

//进度条加载样式情况下的进度条颜色,默认红色
@property (nonatomic, strong) UIColor * progressViewColor;

@end


@interface BTPageLoadViewController : BTViewController<BTPageLoadViewDelegate>

@property (nonatomic, strong, readonly) BTPageLoadView * pageLoadView;

@end

NS_ASSUME_NONNULL_END
