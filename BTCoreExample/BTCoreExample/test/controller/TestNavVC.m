//
//  TestNavVC.m
//  BTCoreExample
//
//  Created by apple on 2021/1/19.
//  Copyright © 2021 stonemover. All rights reserved.
//

#import "TestNavVC.h"
#import <BTHelp/UIImage+BTImage.h>

@interface TestNavVC ()

@end

@implementation TestNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.btNavView = [BTNavigationView createWithParentView:self.view];
    [self.btNavView addLeftItem:[BTNavigationItem itemWithImgName:@"nav_back" width:30]];
    [self.btNavView addRightItems:@[[BTNavigationItem itemWithTitle:@"保存" width:40],[BTNavigationItem itemWithTitle:@"保存" width:40]]];
    self.btNavView.title = @"自定义导航器";
    self.btNavView.bgImg = [UIImage bt_imageWithColor:UIColor.lightGrayColor];
    __weak TestNavVC * weakSelf=self;
    self.btNavView.leftItemClickBlock = ^(BTNavigationItem * _Nonnull item, NSInteger index) {
        [weakSelf bt_leftBarClick];
    };
    self.btNavView.rightItemClickBlock = ^(BTNavigationItem * _Nonnull item, NSInteger index) {
        [BTToast showSuccess:@"保存成功"];
    };
    self.btNavView.titleItemClickBlock = ^(BTNavigationItem * _Nonnull item, NSInteger index) {
        [BTToast showSuccess:@"标题点击成功"];
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btNavView.title = @"导航器";
        [self.btNavView rightItemWithIndex:0].title = @"取消";
        [[self.btNavView rightItemWithIndex:0] update];
    });
}



@end
