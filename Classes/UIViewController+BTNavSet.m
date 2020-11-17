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

- (void)initTitle:(NSString*)title color:(UIColor*)color font:(UIFont*)font{
    self.title=title;
    self.navigationController.navigationBar.titleTextAttributes=@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} ;
}
- (void)initTitle:(NSString *)title color:(UIColor *)color{
    [self initTitle:title color:color font:[BTCoreConfig share].defaultNavTitleFont];
}
- (void)initTitle:(NSString *)title{
    //这个里的color可以根据项目的主题色调一下
    [self initTitle:title color:[BTCoreConfig share].defaultNavTitleColor font:[BTCoreConfig share].defaultNavTitleFont];
}

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



- (void)setItemPaddingDefault{
    [self setItemPadding:BTCoreConfig.share.navItemPadding];
}

- (void)setItemPadding:(CGFloat)padding{
    UINavigationBar * navBar=self.navigationController.navigationBar;
    
    if (@available(iOS 13.0, *)) {
        for (UIView * view in navBar.subviews) {
            if ([NSStringFromClass(view.class) isEqualToString:@"_UINavigationBarContentView"]) {
                for (UILayoutGuide * guide in view.layoutGuides) {
                    if ([guide.identifier hasPrefix:@"BackButtonGuide"]) {
                        NSArray * array = [guide constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal];
                        for (NSLayoutConstraint * c in array) {
                            NSLog(@"%f",c.constant);
                            if (BTCoreConfig.share.navItemPaddingBlock(c)) {
                                if (c.constant > 0) {
                                    c.constant=padding;
                                }else{
                                    c.constant=-padding;
                                }
                            }
                        }
                        
                        break;
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
                    c.constant=padding;
                }else{
                    c.constant=-padding;
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
    [self updateNavItem];
    return [self getLeftBarItem];
}

- (UIBarButtonItem*)getLeftBarItem{
    return [self createItemImg:[UIImage imageNamed:@"nav_back"] action:@selector(leftBarClick)];
}

- (void)updateNavItem{
    [self setItemPaddingDefault];
}


@end
