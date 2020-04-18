//
//  BTViewController.h
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "UIViewController+BTNavSet.h"

//#if __has_include(<BTLoading/UIViewController+BTLoading.h>)
//
//#else
//#import "UIViewController+BTLoading.h"
//#import "BTToast.h"
//#import "BTProgress.h"
//#endif
//
#import <BTLoading/UIViewController+BTLoading.h>
#import <BTLoading/BTToast.h>
#import <BTLoading/BTProgress.h>
#import <RTRootNavigationController/RTRootNavigationController.h>

//#import "UIViewController+BTLoading.h"
//#import "BTToast.h"
//#import "BTProgress.h"

typedef void(^BTVcSuccessBlock)(NSObject * obj);



@interface BTViewController : UIViewController

//是否在触摸结束后关闭键盘，默认true
@property (nonatomic, assign) BOOL isTouceViewEndCloseKeyBoard;

//界面调用viewWillAppear的次数
@property (nonatomic, assign) NSInteger viewWillAppearIndex;

//界面调用viewDidAppear的次数
@property (nonatomic, assign) NSInteger viewDidAppearIndex;

//前后页面的简单回调
@property (nonatomic, copy) BTVcSuccessBlock blockSuccess;

//当vc完全出现后的第一次调用，只会调用一次，用在一些需要在界面完全显示后才需要进行初始化的情况
- (void)viewDidAppearFirst;

//获取数据的方法
- (void)getData;

//重新加载网络数据
- (void)reload;

@end

@interface BTNavigationController : RTRootNavigationController

@end


