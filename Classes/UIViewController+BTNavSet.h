//
//  UIViewController+BTNavSet.h
//  moneyMaker
//
//  Created by stonemover on 2019/1/23.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <BTHelp/UIImage+BTImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (BTNavSet)
- (void)initTitle:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
- (void)initTitle:(NSString*)title color:(UIColor*)color;
- (void)initTitle:(NSString*)title;

- (UIBarButtonItem*)createItemStr:(NSString*)title
                            color:(UIColor*)color
                             font:(UIFont*)font
                           target:(nullable id)target
                           action:(nullable SEL)action;

- (UIBarButtonItem*)createItemStr:(NSString*)title
                           target:(nullable id)target
                           action:(nullable SEL)action;

- (UIBarButtonItem*)createItemStr:(NSString*)title
                           action:(nullable SEL)action;

- (UIBarButtonItem*)createItemImg:(UIImage*)img
                           action:(nullable SEL)action;

- (UIBarButtonItem*)createItemImg:(UIImage*)img
                           target:(nullable id)target
                           action:(nullable SEL)action;

- (void)initRightBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
- (void)initRightBarStr:(NSString*)title color:(UIColor*)color;
- (void)initRightBarStr:(NSString*)title;
- (void)initRightBarImg:(UIImage*)img;
- (void)rightBarClick;

- (void)initLeftBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
- (void)initLeftBarStr:(NSString*)title color:(UIColor*)color;
- (void)initLeftBarStr:(NSString*)title;
- (void)initLeftBarImg:(UIImage*)img;
- (void)leftBarClick;



- (void)setItemPaddingDefault;

- (void)setItemPadding:(CGFloat)padding;

- (void)setNavTrans;


@end

NS_ASSUME_NONNULL_END
