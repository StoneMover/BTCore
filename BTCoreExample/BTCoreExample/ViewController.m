//
//  ViewController.m
//  BTCoreExample
//
//  Created by stonemover on 2019/2/24.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "ViewController.h"
#import <BTWidgetView/UIView+BTViewTool.h>
#import "TestScaleHeadViewController.h"
#import "TestLogViewController.h"
#import "BTLogView.h"
#import "TestWindowViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIWindow * testWindow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitle:@"BTCore"];
    [self.pageLoadView initTableView:@[@"UITableViewCell"] isRegisgerNib:NO];
    [self.pageLoadView.dataArray addObjectsFromArray:@[@"tableView头部伸缩效果",@"WebView加载",@"LogView",@"半屏导航器测试"]];
    [self.pageLoadView setTableViewNoMoreEmptyLine];
    

}



- (id<UITableViewDelegate>)BTPageLoadTableDelegate:(BTPageLoadView *)loadView{
    return self;
}

- (id<UITableViewDataSource>)BTPageLoadTableDataSource:(BTPageLoadView *)loadView{
    return self;
}

#pragma mark tableView data delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.pageLoadView.dataArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:self.pageLoadView.cellId];
    cell.textLabel.text = self.pageLoadView.dataArray[indexPath.row];
    return cell;
}


#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            TestScaleHeadViewController * vc=[TestScaleHeadViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            BTWebViewController * vc=[BTWebViewController new];
            vc.url = @"https://www.baidu.com";
            vc.isTitleFollowWeb = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            TestLogViewController * vc=[TestLogViewController new];
            BTNavigationController * nav = [[BTNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = 0;
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 3:
        {
            //创建蒙层
            UIView * view = [[UIView alloc] init];
            view.backgroundColor = UIColor.blackColor;
            view.alpha = 0.2;
            view.frame = BTUtils.APP_WINDOW.bounds;
            [BTUtils.APP_WINDOW addSubview:view];
            
            //创建测试导航器以及vc
            TestWindowViewController * vc=[TestWindowViewController new];
            BTNavigationController * nav = [[BTNavigationController alloc] initWithRootViewController:vc];
            
            //创建window,并将window的坐标设置在屏幕底部,设置windowLevel防止获取默认window失败
            self.testWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, BTUtils.SCREEN_H, BTUtils.SCREEN_W, BTUtils.SCREEN_H - 200)];
            self.testWindow.windowLevel = UIWindowLevelAlert;
            self.testWindow .backgroundColor = UIColor.redColor;
            [self.testWindow  setBTCornerRadiusTop:10];
            self.testWindow .rootViewController = nav;
            self.testWindow.hidden = NO;
            
            //执行弹出的加载动画
            [UIView animateWithDuration:.35 animations:^{
                self.testWindow .BTTop = 200;
            }];
            
            //消失的回调处理
            __weak ViewController * weakSelf=self;
            vc.blockSuccess = ^(NSObject * _Nullable obj) {
                [UIView animateWithDuration:.35 animations:^{
                    self.testWindow .BTTop = BTUtils.SCREEN_H;
                } completion:^(BOOL finished) {
                    [view removeFromSuperview];
                    weakSelf.testWindow.rootViewController = nil;
                    weakSelf.testWindow = nil;
                }];
                
            };
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

@end
