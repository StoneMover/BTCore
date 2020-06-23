//
//  BTWebViewController.h
//  moneyMaker
//
//  Created by Motion Code on 2019/1/29.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTViewController.h"

typedef NS_ENUM(NSInteger,BTWebViewLoadingType) {
    BTWebViewLoadingDefault = 0,
    BTWebViewLoadingProgress
};

NS_ASSUME_NONNULL_BEGIN

@interface BTWebViewController : BTViewController

@property (nonatomic, strong) NSString * url;

//导航器初始title
@property (nonatomic, strong) NSString * webTitle;

//导航器标题是否跟随网页变化
@property (nonatomic, assign) BOOL isTitleFollowWeb;

//加载中样式
@property (nonatomic, assign) BTWebViewLoadingType loadingType;

//进度条加载样式情况下的进度条颜色,默认红色
@property (nonatomic, strong) UIColor * progressViewColor;

@end

NS_ASSUME_NONNULL_END
