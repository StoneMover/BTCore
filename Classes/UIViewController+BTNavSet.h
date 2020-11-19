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

typedef NS_ENUM(NSInteger,NavItemType) {
    NavItemTypeLeft = 0,
    NavItemTypeRight
};

@interface UIViewController (BTNavSet)

#pragma mark item创建
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

#pragma mark title、leftItem、rightItem初始化
- (void)initTitle:(NSString*)title color:(UIColor*)color font:(UIFont*)font;
- (void)initTitle:(NSString*)title color:(UIColor*)color;
- (void)initTitle:(NSString*)title;

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

#pragma mark 多个item的自定义view初始化
//在item上生成2个或者多个按钮的时候使用该方法
- (void)initCustomeItem:(NavItemType)type str:(NSArray<NSString*>*)strs;
- (void)initCustomeItem:(NavItemType)type img:(NSArray<UIImage*>*)imgs;

//获取相关的配置
- (CGSize)customeItemSize:(NavItemType)type;
- (CGFloat)customePadding:(NavItemType)type;
- (UIColor*)customeStrColor:(NavItemType)type;
- (UIFont*)customeFont:(NavItemType)type;

//点击后的事件
- (void)customeItemClick:(NavItemType)type index:(NSInteger)index;


#pragma mark 其它相关快捷方法
- (void)setItemPaddingDefault;

- (void)setItemPadding:(CGFloat)padding;

- (void)setNavTrans;

- (void)setNavLineHide;

- (void)setNavLineColor:(UIColor*)color;

- (void)setNavLineColor:(UIColor*)color height:(CGFloat)height;

- (CGFloat)bt_NavItemPadding:(NavItemType)type;

@end

NS_ASSUME_NONNULL_END
