//
//  BTNavigationView.h
//  BTWidgetViewExample
//
//  Created by apple on 2021/1/18.
//  Copyright © 2021 stone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BTNavigationItem;

typedef void(^BTNavigationItemClickBlock)(BTNavigationItem * item, NSInteger index);

@interface BTNavigationView : UIView

+ (instancetype)createWithParentView:(UIView*)view;

@property (nonatomic, strong, nullable) BTNavigationItem * centerItem;

@property (nonatomic, copy) BTNavigationItemClickBlock leftItemClickBlock;

@property (nonatomic, copy) BTNavigationItemClickBlock rightItemClickBlock;

@property (nonatomic, copy) BTNavigationItemClickBlock titleItemClickBlock;

@property (nonatomic, strong) NSString * title;

@property (nonatomic, strong) UIImage * bgImg;

- (void)addLeftItem:(BTNavigationItem*)item;
- (void)addLeftItems:(NSArray<BTNavigationItem*>*)items;
- (void)clearLeftItem:(BTNavigationItem*)item;
- (void)clearAllLeftItem;

- (void)addRightItem:(BTNavigationItem*)item;
- (void)addRightItems:(NSArray<BTNavigationItem*>*)items;
- (void)clearRightItem:(BTNavigationItem*)item;
- (void)clearAllRightItem;

- (BTNavigationItem*)leftItemWithIndex:(NSInteger)index;
- (BTNavigationItem*)rightItemWithIndex:(NSInteger)index;

- (void)setLineHeight:(CGFloat)height color:(UIColor*)color;



@end


typedef NS_ENUM(NSInteger,BTNavigationItemType) {
    BTNavigationItemStr = 0,
    BTNavigationItemImg,
    BTNavigationItemCustome
};

@interface BTNavigationItem : NSObject

+ (instancetype)itemWithTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color width:(CGFloat)width;

+ (instancetype)itemWithTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color;

+ (instancetype)itemWithTitle:(NSString*)title;

+ (instancetype)itemWithTitle:(NSString*)title width:(CGFloat)width;

+ (instancetype)itemWithImg:(UIImage*)img width:(CGFloat)width;

+ (instancetype)itemWithImg:(UIImage*)img;

+ (instancetype)itemWithImgName:(NSString*)imgName;

+ (instancetype)itemWithImgName:(NSString*)imgName width:(CGFloat)width;

+ (instancetype)itemWithCustomeView:(UIView*)customeView;

@property (nonatomic, assign) BTNavigationItemType type;

@property (nonatomic, strong, nullable) NSString * title;

@property (nonatomic, strong, nullable) UIFont * font;

@property (nonatomic, strong, nullable) UIColor * color;

@property (nonatomic, strong, nullable) UIImage * img;

//距离上一个Item以及父view左右两端的间距，默认为5
@property (nonatomic, assign) CGFloat margin;

//自定义布局，不提供点击事件回调
@property (nonatomic, strong,nullable) UIView * customeView;

//展示在导航器上的最终view,可以设置自身的hidden来隐藏
@property (nonatomic, strong) UIView * resultView;

//最小的宽度，如果控件计算小于该值，则将控件宽度设置为此值，不包括自定义View
@property (nonatomic, assign) CGFloat miniWidth;

//跟新数据后调用刷新界面
- (void)update;

@end

NS_ASSUME_NONNULL_END
