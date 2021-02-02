//
//  TestLogViewController.m
//  BTCoreExample
//
//  Created by apple on 2020/9/7.
//  Copyright © 2020 stonemover. All rights reserved.
//

#import "TestLogViewController.h"
#import "BTLogView.h"

@interface TestLogViewController ()

@end

@implementation TestLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bt_initTitle:@"LogView"];
    
    [BTLogView.share addAndSave:@"保存的log日志"];
    [self bt_initLeftBarStr:@"取消"];
    
    BTCoreConfig.share.isOpenLog = YES;
    [BTLogView.share show];
}

- (void)bt_leftBarClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addLog{
    [BTLogView.share add:@"tt"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addLog];
    });
}



@end
