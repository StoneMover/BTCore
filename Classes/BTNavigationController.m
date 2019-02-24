//
//  BTNavigationController.m
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTNavigationController.h"
#import "Const.h"

@interface BTNavigationController ()

@end

@implementation BTNavigationController

- (void)viewDidLoad {
    self.transferNavigationBarAttributes = true;
    self.useSystemBackBarButtonItem = false;
    [super viewDidLoad];
    self.navigationBar.translucent = false;
    self.navigationBar.tintColor=KBlackColor;
    self.navigationBar.barTintColor = KWhiteColor;
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
