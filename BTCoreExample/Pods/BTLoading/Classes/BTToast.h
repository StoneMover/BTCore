//
//  BTToast.h
//  loadinghelp
//
//  Created by stonemover on 2018/8/11.
//  Copyright © 2018年 StoneMover. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,BTToastStyle) {
    BTToastStyleCenter=0,
};



@interface BTToast : UIView

+ (BTToast*)show:(NSString*)str;
+ (BTToast*)show:(NSString*)str img:(UIImage*)img;
+ (BTToast*)showSuccess:(NSString*)str;
+ (BTToast*)showWarning:(NSString*)str;
+ (BTToast*)showError:(NSString*)str;
+ (BTToast*)showErrorObj:(NSError*)error;


//是否可以在Toast的过程中点击屏幕内容，默认可以
@property (nonatomic, assign) BOOL isClickInToast;

//显示后消失的时间，默认2s
@property (nonatomic, assign) CGFloat delayDismissTime;

- (instancetype)init:(BTToastStyle)style str:(NSString*)str img:(UIImage*)img;

- (void)show:(UIView*)rootView;

@end
