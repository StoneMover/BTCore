//
//  BTViewController.m
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTViewController.h"
#import <BTHelp/BTUtils.h>
#import <BTHelp/UIColor+BTColor.h>


@interface BTViewController ()

@end

@implementation BTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor RGBSame:247];
    self.isTouceViewEndCloseKeyBoard=YES;
}

#pragma mark 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.viewWillAppearIndex++;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.viewDidAppearIndex==0) {
        [self viewDidAppearFirst];
    }
    self.viewDidAppearIndex++;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidAppearFirst{
    
}

#pragma mark loading
- (void)getData{
    
}

- (void)bt_loadingReload{
    [super bt_loadingReload];
    [self getData];
}




@end


@implementation BTNavigationController

- (void)viewDidLoad {
    self.transferNavigationBarAttributes = true;
    self.useSystemBackBarButtonItem = false;
    [super viewDidLoad];
    self.navigationBar.translucent = false;
    self.navigationBar.tintColor=UIColor.blackColor;
    self.navigationBar.barTintColor = UIColor.whiteColor;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

//- (void)_layoutViewController:(NSObject*)obj{
//    //    [super layoutViewController];
//}





@end
