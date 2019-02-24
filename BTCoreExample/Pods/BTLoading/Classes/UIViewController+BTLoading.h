//
//  UIViewController+BTLoading.h
//  loadinghelp
//
//  Created by stonemover on 2018/8/8.
//  Copyright © 2018年 StoneMover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTLoadingView.h"

@interface UIViewController (BTLoading)

@property (nonatomic, strong) BTLoadingView * loadingHelp;

- (void)initLoading;
- (void)initLoading:(CGRect)rect;
- (void)initLoading:(CGRect)rect isLoading:(BOOL)isLoading;

- (void)showLoading;
- (void)showEmpty;
- (void)showNetError;
- (void)showServerError;

- (void)dismiss;
- (void)reload;

@end
