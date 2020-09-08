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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitle:@"BTCore"];
    [self.pageLoadView initTableView:@[@"UITableViewCell"] isRegisgerNib:NO];
    [self.pageLoadView.dataArray addObjectsFromArray:@[@"tableView头部伸缩效果",@"WebView加载",@"LogView"]];
    [self.pageLoadView setTableViewNoMoreEmptyLine];
    
    BTCoreConfig.share.isOpenLog = YES;
    [BTLogView.share show];
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
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

@end
