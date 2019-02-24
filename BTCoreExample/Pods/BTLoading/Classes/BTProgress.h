//
//  BTProgress.h
//  loadinghelp
//
//  Created by stonemover on 2018/8/11.
//  Copyright © 2018年 StoneMover. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BTProgressStyle) {
    BTProgressStyleLoading=0,
    BTProgressStyleProgress
};

@interface BTProgress : UIView

+ (BTProgress*)showLoading:(NSString*)str;
+ (BTProgress*)showLoading;
+ (void)hideLoading;

- (void)show:(UIView*)view ;

@end
