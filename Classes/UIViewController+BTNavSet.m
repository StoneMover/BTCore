//
//  UIViewController+BTNavSet.m
//  moneyMaker
//
//  Created by stonemover on 2019/1/23.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "UIViewController+BTNavSet.h"
#import <BTHelp/UIImage+BTImage.h>
#import "BTCoreConfig.h"
#import <BTHelp/BTUtils.h>

@implementation UIViewController (BTNavSet)



- (UIBarButtonItem*)createItemStr:(NSString*)title
                            color:(UIColor*)color
                             font:(UIFont*)font
                           target:(nullable id)target
                           action:(nullable SEL)action{
    UIBarButtonItem * item=[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    return item;
}

- (UIBarButtonItem*)createItemStr:(NSString*)title
                           target:(nullable id)target
                           action:(nullable SEL)action{
    return [self createItemStr:title color:[UIColor redColor] font:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] target:target action:action];
}

- (UIBarButtonItem*)createItemStr:(NSString*)title
                           action:(nullable SEL)action{
    return [self createItemStr:title color:[UIColor redColor] font:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium] target:self action:action];
}

- (UIBarButtonItem*)createItemImg:(UIImage*)img
                           action:(nullable SEL)action{
    return [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:action];
}

- (UIBarButtonItem*)createItemImg:(UIImage*)img
                           target:(nullable id)target
                           action:(nullable SEL)action{
    return [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:target action:action];
}


- (void)initTitle:(NSString*)title color:(UIColor*)color font:(UIFont*)font{
    self.title=title;
    self.navigationController.navigationBar.titleTextAttributes=@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} ;
}
- (void)initTitle:(NSString *)title color:(UIColor *)color{
    [self initTitle:title color:color font:[BTCoreConfig share].defaultNavTitleFont];
}
- (void)initTitle:(NSString *)title{
    [self initTitle:title color:[BTCoreConfig share].defaultNavTitleColor font:[BTCoreConfig share].defaultNavTitleFont];
}


- (void)initRightBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font{
    UIBarButtonItem * item=[self createItemStr:title color:color font:font target:self action:@selector(rightBarClick)];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem=item;
    
}
- (void)initRightBarStr:(NSString*)title color:(UIColor*)color{
    [self initRightBarStr:title color:[BTCoreConfig share].defaultNavRightBarItemColor font:[BTCoreConfig share].defaultNavRightBarItemFont];
}
- (void)initRightBarStr:(NSString*)title{
    [self initRightBarStr:title color:[BTCoreConfig share].defaultNavRightBarItemColor];
}
- (void)initRightBarImg:(UIImage*)img{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClick)];
}
- (void)rightBarClick;{
    
}


- (void)initLeftBarStr:(NSString*)title color:(UIColor*)color font:(UIFont*)font{
    UIBarButtonItem * item=[self createItemStr:title color:color font:font target:self action:@selector(leftBarClick)];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    self.navigationItem.leftBarButtonItem=item;
}
- (void)initLeftBarStr:(NSString*)title color:(UIColor*)color{
    [self initLeftBarStr:title color:color font:[BTCoreConfig share].defaultNavLeftBarItemFont];
}
- (void)initLeftBarStr:(NSString*)title{
    [self initLeftBarStr:title color:[BTCoreConfig share].defaultNavLeftBarItemColor];
}
- (void)initLeftBarImg:(UIImage*)img{
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(leftBarClick)];
}
- (void)leftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initCustomeItem:(NavItemType)type str:(NSArray<NSString*>*)strs{
    CGSize size = [self customeItemSize:type];
    CGFloat padding = [self customePadding:type];
    UIFont * font = [self customeFont:type];
    UIColor * color = [self customeStrColor:type];
    UIView * parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width * strs.count + (strs.count - 1) * padding, size.height)];
    NSInteger index = 0;
    for (NSString * str in strs) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(index * (size.width + padding), 0, size.width, size.height)];
        [btn setTitle:str forState:UIControlStateNormal];
        [btn setTitleColor:color forState:UIControlStateNormal];
        btn.titleLabel.font = font;
        btn.tag = index;
        [parentView addSubview:btn];
        if (type == NavItemTypeRight) {
            [btn addTarget:self action:@selector(customeItemRightClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if(type == NavItemTypeLeft){
            [btn addTarget:self action:@selector(customeItemLeftClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        index++;
    }
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:parentView];
    if (type == NavItemTypeRight) {
        self.navigationItem.rightBarButtonItem = item;
    }else if(type == NavItemTypeLeft){
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)initCustomeItem:(NavItemType)type img:(NSArray<UIImage*>*)imgs{
    CGSize size = [self customeItemSize:type];
    CGFloat padding = [self customePadding:type];
    UIView * parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width * imgs.count + (imgs.count - 1) * padding, size.height)];
    NSInteger index = 0;
    for (UIImage * img in imgs) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(index * (size.width + padding), 0, size.width, size.height)];
        [btn setImage:img forState:UIControlStateNormal];
        btn.tag = index;
        [parentView addSubview:btn];
        if (type == NavItemTypeRight) {
            [btn addTarget:self action:@selector(customeItemRightClick:) forControlEvents:UIControlEventTouchUpInside];
        }else if(type == NavItemTypeLeft){
            [btn addTarget:self action:@selector(customeItemLeftClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        index++;
    }
    if (type == NavItemTypeRight) {
        self.navigationItem.leftBarButtonItem.customView = parentView;
    }else if(type == NavItemTypeLeft){
        self.navigationItem.rightBarButtonItem.customView = parentView;
    }
}

- (CGSize)customeItemSize:(NavItemType)type{
    return CGSizeMake(44, 44);
}
- (CGFloat)customePadding:(NavItemType)type{
    return 0;
}

- (UIFont *)customeFont:(NavItemType)type{
    if (type == NavItemTypeLeft) {
        return BTCoreConfig.share.defaultNavLeftBarItemFont;
    }
    return BTCoreConfig.share.defaultNavRightBarItemFont;
}

- (UIColor*)customeStrColor:(NavItemType)type{
    if (type == NavItemTypeLeft) {
        return BTCoreConfig.share.defaultNavLeftBarItemColor;
    }
    return BTCoreConfig.share.defaultNavRightBarItemColor;
}

- (void)customeItemLeftClick:(UIButton*)btn{
    [self customeItemClick:NavItemTypeLeft index:btn.tag];
}

- (void)customeItemRightClick:(UIButton*)btn{
    [self customeItemClick:NavItemTypeRight index:btn.tag];
}

- (void)customeItemClick:(NavItemType)type index:(NSInteger)index{
    
}

- (void)setItemPaddingDefault{
    [self setItemPadding:[self bt_NavItemPadding:NavItemTypeLeft]
            rightPadding:[self bt_NavItemPadding:NavItemTypeRight]];
}

- (void)setItemPadding:(CGFloat)padding{
    [self setItemPadding:padding rightPadding:padding];
}

- (void)setItemPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding{
    UINavigationBar * navBar=self.navigationController.navigationBar;
    
    if (@available(iOS 12.0, *)) {
        for (UIView * view in navBar.subviews) {
            if ([NSStringFromClass(view.class) isEqualToString:@"_UINavigationBarContentView"]) {
                for (UILayoutGuide * guide in view.layoutGuides) {
                    NSLog(@"%@",guide.identifier);
                    if ([guide.identifier hasPrefix:@"BackButtonGuide"]) {
                        NSArray * array = [guide constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal];
                        for (NSLayoutConstraint * c in array) {
                            NSLog(@"%f",c.constant);
                            if (BTCoreConfig.share.navItemPaddingBlock(c)) {
                                if (c.constant > 0) {
                                    c.constant=leftPadding;
                                }else{
                                    c.constant=-leftPadding;
                                }
                                break;
                            }
                        }
                        
                        break;
                    }
                    
                }
                
                if (self.navigationItem.rightBarButtonItem || self.navigationItem.rightBarButtonItems) {
                    for (UILayoutGuide * guide in view.layoutGuides) {
                        NSLog(@"%@",guide.identifier);
                        if ([guide.identifier hasPrefix:@"TrailingBarGuide"]) {
                            NSArray * array = [guide constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal];
                            for (NSLayoutConstraint * c in array) {
                                NSLog(@"%f",c.constant);
                                if (BTCoreConfig.share.navItemPaddingBlock(c)) {
                                    if (c.constant > 0) {
                                        c.constant=rightPadding;
                                    }else{
                                        c.constant=-rightPadding;
                                    }
                                    break;
                                }
                            }
                            
                            break;
                        }
                        
                    }
                }
                
                break;
            }
            
        }
        
        return;
    }
    
    for (UIView * view in navBar.subviews) {
        for (NSLayoutConstraint *c  in view.constraints) {
//            NSLog(@"%f",c.constant);
            if (BTCoreConfig.share.navItemPaddingBlock(c)) {
                if (c.constant > 0) {
                    c.constant=leftPadding;
                }else{
                    c.constant=-leftPadding;
                }
            }
        }
    }
}

- (void)setNavTrans{
    self.navigationController.navigationBar.translucent = true;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage bt_imageWithColor:UIColor.clearColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setClipsToBounds:YES];
    self.navigationController.navigationBar.backgroundColor=UIColor.clearColor;
}

- (void)setNavLineHide{
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)setNavLineColor:(UIColor*)color{
    [self setNavLineColor:color height:.5];
}

- (void)setNavLineColor:(UIColor*)color height:(CGFloat)height{
    [self.navigationController.navigationBar setShadowImage:[UIImage bt_imageWithColor:color size:CGSizeMake([UIScreen mainScreen].bounds.size.width, height)]];
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action{
    [self setItemPaddingDefault];
    UIBarButtonItem * item = [self createItemImg:[UIImage imageNamed:@"nav_back"] action:@selector(leftBarClick)];
    return item;
}



- (CGFloat)bt_NavItemPadding:(NavItemType)type{
    return BTCoreConfig.share.navItemPadding;
}


@end
