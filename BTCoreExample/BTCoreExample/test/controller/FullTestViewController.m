//
//  FullTestViewController.m
//  BTCoreExample
//
//  Created by apple on 2020/10/26.
//  Copyright © 2020 stonemover. All rights reserved.
//

#import "FullTestViewController.h"
#import <BTWidgetView/UIView+BTConstraint.h>
#import "AppDelegate.h"

@interface FullTestViewController ()

@end

@implementation FullTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bt_initTitle:@"横竖屏测试"];
    
    UIButton * btnLand = [[UIButton alloc] init];
    btnLand.translatesAutoresizingMaskIntoConstraints = NO;
    btnLand.backgroundColor = UIColor.redColor;
    [self.view addSubview:btnLand];
    [btnLand setTitle:@"横屏" forState:UIControlStateNormal];
    [btnLand addTarget:self action:@selector(landClick) forControlEvents:UIControlEventTouchUpInside];
    [btnLand bt_addWidth:120];
    [btnLand bt_addHeight:50];
    [btnLand bt_addLeftToItemView:self.view];
    [btnLand bt_addTopToItemView:self.view];
    
    UIButton * btnPortrait = [[UIButton alloc] init];
    btnPortrait.translatesAutoresizingMaskIntoConstraints = NO;
    btnPortrait.backgroundColor = UIColor.redColor;
    [self.view addSubview:btnPortrait];
    [btnPortrait setTitle:@"竖屏" forState:UIControlStateNormal];
    [btnPortrait addTarget:self action:@selector(portraitClick) forControlEvents:UIControlEventTouchUpInside];
    [btnPortrait bt_addWidth:120];
    [btnPortrait bt_addHeight:50];
    [btnPortrait bt_addLeftToItemView:self.view];
    [btnPortrait bt_addTopToItemView:btnLand constant:10];
    
    [self landClick];
}

- (void)bt_leftBarClick{
    [self portraitClick];
    [super bt_leftBarClick];
    
}

- (void)landClick{
    [self forceOrientationLandscape];
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];

    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)portraitClick{
    //强制旋转竖屏
       [self forceOrientationPortrait];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
        //设置屏幕的转向为竖屏
       [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
       //刷新
       [UIViewController attemptRotationToDeviceOrientation];
}

//强制横屏
- (void)forceOrientationLandscape
{
  AppDelegate * appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
  appdelegate.isForceLandscape=YES;
  appdelegate.isForcePortrait=NO;
  [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

//强制竖屏
- (void)forceOrientationPortrait
{
  AppDelegate * appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
  appdelegate.isForcePortrait=YES;
  appdelegate.isForceLandscape=NO;
  [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

//设置是否允许自动旋转
- (BOOL)shouldAutorotate {
    return YES;
}

//设置支持的屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
}

//设置presentation方式展示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait;
}

@end
