//
//  BTViewController.m
//  moneyMaker
//
//  Created by stonemover on 2019/1/22.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTViewController.h"
#import "Const.h"


@interface BTViewController ()

@end

@implementation BTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=KRGBColor(247, 247, 247);
}

#pragma mark 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark loading
- (void)getData{
    
}
- (void)reload{
    [super reload];
    [self getData];
}



@end
