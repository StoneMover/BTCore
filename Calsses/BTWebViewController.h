//
//  BTWebViewController.h
//  moneyMaker
//
//  Created by Motion Code on 2019/1/29.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "BTViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTWebViewController : BTViewController

@property (nonatomic, strong) NSString * url;

//是否需要底部的工具栏，默认不需要
@property (nonatomic, assign) BOOL isNeedToolBar;

//导航器初始title
@property (nonatomic, strong) NSString * webTitle;

//导航器标题是否不跟随网页变化
@property (nonatomic, assign) BOOL isTitleNoFlowWeb;

@end

NS_ASSUME_NONNULL_END
