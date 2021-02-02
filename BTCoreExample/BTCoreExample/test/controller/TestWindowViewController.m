//
//  TestWindowViewController.m
//  BTCoreExample
//
//  Created by apple on 2020/9/9.
//  Copyright © 2020 stonemover. All rights reserved.
//

#import "TestWindowViewController.h"
#import "ViewController.h"
#import <BTWidgetView/UIView+BTViewTool.h>

@interface TestWindowViewController ()

@end

@implementation TestWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bt_initLeftBarStr:@"取消"];
    [self bt_initRightBarStr:@"下一级界面"];
    [self bt_initTitle:@"半屏导航器"];
}

- (void)leftBarClick{
//    UIView * rootView = self.view;
//    while (rootView.superview) {
//        rootView = rootView.superview;
//    }
//
//    UIWindow * window = (UIWindow*)rootView;
//    [window bt_removeAllChildView];
//    window.rootViewController = nil;
//    window = nil;
    self.blockSuccess(nil);
}

- (void)dealloc{
    NSLog(@"te");
}

- (void)rightBarClick{
    ViewController * vc=[ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
