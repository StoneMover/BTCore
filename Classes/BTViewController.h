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

//#import "UIViewController+BTLoading.h"
//#import "BTToast.h"
//#import "BTProgress.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTViewController : UIViewController

//是否在触摸结束后关闭键盘，默认true
@property (nonatomic, assign) BOOL isTouceViewEndCloseKeyBoard;

//界面调用viewWillAppear的次数
@property (nonatomic, assign) NSInteger viewWillAppearIndex;

//界面调用viewDidAppear的次数
@property (nonatomic, assign) NSInteger viewDidAppearIndex;

- (void)getData;
- (void)reload;
@end

NS_ASSUME_NONNULL_END
