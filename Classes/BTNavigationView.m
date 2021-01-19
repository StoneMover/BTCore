//
//  BTNavigationView.m
//  BTWidgetViewExample
//
//  Created by apple on 2021/1/18.
//  Copyright © 2021 stone. All rights reserved.
//

#import "BTNavigationView.h"
#import <BTWidgetView/UIView+BTConstraint.h>
#import <BTHelp/BTUtils.h>
#import <BTWidgetView/UIView+BTViewTool.h>
#import "BTCoreConfig.h"
#import <BTHelp/UIColor+BTColor.h>
#import <BTWidgetView/UIFont+BTFont.h>

@interface BTNavigationView()

@property (nonatomic, strong) NSMutableArray<BTNavigationItem*> * leftItemArray;

@property (nonatomic, strong) NSMutableArray<BTNavigationItem*> * rightItemArray;

@property (nonatomic, strong) UIImageView * bgImgView;

@property (nonatomic, strong) UIView * lineView;

@end


@implementation BTNavigationView

+ (instancetype)createWithParentView:(UIView*)view{
    BTNavigationView * navView = [BTNavigationView new];
    [view addSubview:navView];
    navView.translatesAutoresizingMaskIntoConstraints = NO;
    [navView bt_addTopToParent];
    [navView bt_addLeftToParent];
    return navView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self initSelf];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    [self initSelf];
    return self;
}

- (void)initSelf{
    self.backgroundColor = UIColor.whiteColor;
    
    [self bt_addWidth:BTUtils.SCREEN_W];
    [self bt_addHeight:BTUtils.NAV_HEIGHT];
    
    self.leftItemArray = [NSMutableArray new];
    self.rightItemArray = [NSMutableArray new];
    self.bgImgView = [UIImageView new];
    [self addSubview:self.bgImgView];
    
    self.lineView = [UIView new];
    self.lineView.BTHeight = 0.5;
    self.lineView.backgroundColor = UIColor.bt_235Color;
    [self addSubview:self.lineView];
}


- (void)layoutSubviews{
    CGFloat leftX = 0;
    CGFloat rightX = BTUtils.SCREEN_W;
    CGFloat top = BTUtils.NAV_HEIGHT - BTUtils.NAVCONTENT_HEIGHT;
    if (self.leftItemArray.count > 0) {
        leftX = self.leftItemArray.firstObject.margin;
    }
    if (self.rightItemArray.count > 0) {
        rightX -= self.rightItemArray.firstObject.margin;
    }
    for (BTNavigationItem * item in self.leftItemArray) {
        item.resultView.frame = CGRectMake(leftX, top, item.resultView.BTWidth, BTUtils.NAVCONTENT_HEIGHT);
        leftX += item.resultView.BTWidth;
        if (self.leftItemArray.lastObject != item) {
            NSInteger nowIndex = [self.leftItemArray indexOfObject:item];
            leftX += self.leftItemArray[nowIndex + 1].margin;
        }
    }
    
    for (BTNavigationItem * item in self.rightItemArray) {
        item.resultView.frame = CGRectMake(rightX - item.resultView.BTWidth, top, item.resultView.BTWidth, BTUtils.NAVCONTENT_HEIGHT);
        rightX -= item.resultView.BTWidth;
        if (self.rightItemArray.lastObject != item) {
            NSInteger nowIndex = [self.rightItemArray indexOfObject:item];
            leftX -= self.rightItemArray[nowIndex + 1].margin;
        }
    }
    
    if (self.centerItem) {
        self.centerItem.resultView.frame = CGRectMake((self.BTWidth - self.centerItem.resultView.BTWidth)/2.0, top, self.centerItem.resultView.BTWidth, BTUtils.NAVCONTENT_HEIGHT);
    }
    
    self.bgImgView.frame = self.bounds;
    self.lineView.frame = CGRectMake(0, self.BTHeight - self.lineView.BTHeight, self.BTWidth, self.lineView.BTHeight);
}

- (void)setCenterItem:(BTNavigationItem *)centerItem{
    if (_centerItem != nil) {
        [self.centerItem.customeView removeFromSuperview];
        _centerItem = nil;
    }
    
    
    
    _centerItem = centerItem;
    [self addSubview:centerItem.resultView];
    [self layoutSubviews];
    if ([centerItem.resultView isKindOfClass:[UIButton class]]) {
        UIButton * btn = (UIButton*)centerItem.resultView;
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)addLeftItem:(BTNavigationItem*)item{
    [self.leftItemArray addObject:item];
    [self addSubview:item.resultView];
    [self layoutSubviews];
    if ([item.resultView isKindOfClass:[UIButton class]]) {
        UIButton * btn = (UIButton*)item.resultView;
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)addLeftItems:(NSArray<BTNavigationItem*>*)items{
    for (BTNavigationItem * item in items) {
        [self addLeftItem:item];
    }
}

- (void)clearLeftItem:(BTNavigationItem*)item{
    [self.leftItemArray removeObject:item];
    [item.resultView removeFromSuperview];
    [self layoutSubviews];
}

- (void)clearAllLeftItem{
    for (BTNavigationItem * item in self.leftItemArray) {
        [item.resultView removeFromSuperview];
    }
    [self.leftItemArray removeAllObjects];
    [self layoutSubviews];
}

- (void)addRightItem:(BTNavigationItem*)item{
    [self.rightItemArray addObject:item];
    [self addSubview:item.resultView];
    [self layoutSubviews];
    if ([item.resultView isKindOfClass:[UIButton class]]) {
        UIButton * btn = (UIButton*)item.resultView;
        [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)addRightItems:(NSArray<BTNavigationItem*>*)items{
    for (BTNavigationItem * item in items) {
        [self addRightItem:item];
    }
}

- (void)clearRightItem:(BTNavigationItem*)item{
    [self.rightItemArray removeObject:item];
    [item.resultView removeFromSuperview];
    [self layoutSubviews];
}

- (void)clearAllRightItem{
    for (BTNavigationItem * item in self.rightItemArray) {
        [item.resultView removeFromSuperview];
    }
    [self.rightItemArray removeAllObjects];
    [self layoutSubviews];
}

- (BTNavigationItem*)leftItemWithIndex:(NSInteger)index{
    return self.leftItemArray[index];
}
- (BTNavigationItem*)rightItemWithIndex:(NSInteger)index{
    return self.rightItemArray[index];
}

- (void)setTitle:(NSString*)title{
    _title = title;
    if (self.centerItem.type != BTNavigationItemStr || !self.centerItem) {
        self.centerItem = [BTNavigationItem itemWithTitle:title font:BTCoreConfig.share.defaultNavTitleFont color:BTCoreConfig.share.defaultNavTitleColor];
    }else{
        self.centerItem.title = title;
        [self.centerItem update];
    }
    
}

- (void)setBgImg:(UIImage *)bgImg{
    _bgImg = bgImg;
    self.bgImgView.image = bgImg;
}

- (void)setLineHeight:(CGFloat)height color:(UIColor*)color{
    self.lineView.BTHeight = height;
    self.lineView.BTBottom = self.BTHeight;
    self.lineView.backgroundColor = color;
}

- (void)itemClick:(UIButton*)sender{
    if (self.leftItemClickBlock) {
        for (int i=0; i<self.leftItemArray.count; i++) {
            if (self.leftItemArray[i].resultView == sender) {
                self.leftItemClickBlock(self.leftItemArray[i], i);
                return;
            }
        }
    }
    
    if (self.rightItemClickBlock) {
        for (int i=0; i<self.rightItemArray.count; i++) {
            if (self.rightItemArray[i].resultView == sender) {
                self.rightItemClickBlock(self.rightItemArray[i], i);
                return;
            }
        }
    }
    
    if (self.titleItemClickBlock && self.centerItem.resultView == sender) {
        self.titleItemClickBlock(self.centerItem, 0);
    }
    
}

@end


@implementation BTNavigationItem

+ (instancetype)itemWithTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color width:(CGFloat)width{
    BTNavigationItem * item = [BTNavigationItem new];
    item.type = BTNavigationItemStr;
    item.title = title;
    item.font = font;
    item.color = color;
    item.miniWidth = width;
    [item update];
    return item;
}


+ (instancetype)itemWithTitle:(NSString*)title font:(UIFont*)font color:(UIColor*)color{
    return [self itemWithTitle:title font:font color:color width:0];
}

+ (instancetype)itemWithTitle:(NSString*)title{
    return [self itemWithTitle:title font:[UIFont BTAutoFontWithSize:16 weight:UIFontWeightMedium] color:BTCoreConfig.share.mainColor width:0];
}

+ (instancetype)itemWithTitle:(NSString*)title width:(CGFloat)width{
    return [self itemWithTitle:title font:[UIFont BTAutoFontWithSize:16 weight:UIFontWeightMedium] color:BTCoreConfig.share.mainColor width:width];
}

+ (instancetype)itemWithImg:(UIImage*)img width:(CGFloat)width{
    BTNavigationItem * item = [BTNavigationItem new];
    item.type = BTNavigationItemImg;
    item.img = img;
    item.miniWidth = width;
    [item update];
    return item;
}

+ (instancetype)itemWithImg:(UIImage*)img{
    return [self itemWithImg:img width:0];
}

+ (instancetype)itemWithImgName:(NSString*)imgName{
    return [self itemWithImg:[UIImage imageNamed:imgName] width:0];
}

+ (instancetype)itemWithImgName:(NSString*)imgName width:(CGFloat)width{
    return [self itemWithImg:[UIImage imageNamed:imgName] width:width];
}

+ (instancetype)itemWithCustomeView:(UIView*)customeView{
    BTNavigationItem * item = [BTNavigationItem new];
    item.type = BTNavigationItemCustome;
    item.customeView = customeView;
    item.resultView = customeView;
    return item;
}

- (instancetype)init{
    self = [super init];
    self.margin = BTCoreConfig.share.navItemPadding;
    return self;
}

- (void)update{
    if (self.resultView) {
        switch (self.type) {
            case BTNavigationItemStr:
            {
                if ([self.resultView isKindOfClass:[UIButton class]]) {
                    UIButton * btn = (UIButton*)self.resultView;
                    [btn setTitle:self.title forState:UIControlStateNormal];
                    [btn sizeToFit];
                    if (btn.BTWidth < self.miniWidth) {
                        btn.BTWidth = self.miniWidth;
                    }
                }
            }
                break;
            case BTNavigationItemImg:
            {
                if ([self.resultView isKindOfClass:[UIButton class]]) {
                    UIButton * btn = (UIButton*)self.resultView;
                    [btn setImage:self.img forState:UIControlStateNormal];
                    [btn sizeToFit];
                    if (btn.BTWidth < self.miniWidth) {
                        btn.BTWidth = self.miniWidth;
                    }
                }
            }
                break;
            case BTNavigationItemCustome:
            {
                
            }
                break;
        }
        
        [self.resultView.superview layoutIfNeeded];
        return;
    }
    
    switch (self.type) {
        case BTNavigationItemStr:
        {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [btn setTitle:self.title forState:UIControlStateNormal];
            [btn setTitleColor:self.color forState:UIControlStateNormal];
            btn.titleLabel.font = self.font;
            [btn sizeToFit];
            if (btn.BTWidth < self.miniWidth) {
                btn.BTWidth = self.miniWidth;
            }
            self.resultView = btn;
        }
            break;
        case BTNavigationItemImg:
        {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [btn setImage:self.img forState:UIControlStateNormal];
            [btn sizeToFit];
            if (btn.BTWidth < self.miniWidth) {
                btn.BTWidth = self.miniWidth;
            }
            self.resultView = btn;
        }
            break;
        case BTNavigationItemCustome:
        {
            
        }
            break;
    }
}

@end
