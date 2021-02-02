//
//  TestScaleHeadViewController.m
//  BTCoreExample
//
//  Created by apple on 2020/9/4.
//  Copyright © 2020 stonemover. All rights reserved.
//

#import "TestScaleHeadViewController.h"

@interface TestScaleHeadViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView * testImgView;

@end

@implementation TestScaleHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bt_initTitle:@"tableView头部伸缩效果"];
    [self.pageLoadView initTableView:@[@"UITableViewCell"] isRegisgerNib:NO];
    [self.pageLoadView setTableViewNoMoreEmptyLine];
    
    [self.pageLoadView.tableView setContentInset:UIEdgeInsetsMake(100, 0, 0, 0)];
    
    self.pageLoadView.tableView.backgroundColor = UIColor.clearColor;
    
    UIImageView * bgView =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BTUtils.SCREEN_W, 100)];
    bgView.clipsToBounds = YES;
    bgView.image = [UIImage imageNamed:@"test"];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    self.testImgView = bgView;
    [self.pageLoadView insertSubview:bgView atIndex:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (fabs(scrollView.contentOffset.y) > 100) {
        self.testImgView.BTHeight = fabs(scrollView.contentOffset.y);
        self.testImgView.BTTop = 0;
    }else{
        self.testImgView.BTHeight = 100;
        self.testImgView.BTTop = -(scrollView.contentOffset.y + 100);
    }
    
    
}

- (id<UITableViewDelegate>)BTPageLoadTableDelegate:(BTPageLoadView *)loadView{
    return self;
}

- (id<UITableViewDataSource>)BTPageLoadTableDataSource:(BTPageLoadView *)loadView{
    return self;
}

#pragma mark tableView data delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:self.pageLoadView.cellId];
    cell.textLabel.text = @"测试";
    return cell;
}


#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

@end
