//
//  BTViewController.m
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTViewController.h"
#import <BTHelp/BTUtils.h>


@interface BTViewController ()

@end

@implementation BTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[BTUtils RGB:247 G:247 B:247];
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
- (void)reload{
    [super reload];
    [self getData];
}



@end
