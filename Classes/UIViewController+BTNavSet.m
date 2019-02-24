//
//  UIViewController+BTNavSet.m
//  moneyMaker
//
//  Created by stonemover on 2019/1/23.
//  Copyright © 2019 stonemover. All rights reserved.
//

#import "UIViewController+BTNavSet.h"
#import "Const.h"
#import <BTHelp/UIImage+BTImage.h>

@implementation UIViewController (BTNavSet)

- (void)initTitle:(NSString*)title color:(UIColor*)color font:(UIFont*)font{
    self.title=title;
    self.navigationController.navigationBar.titleTextAttributes=@{NSFontAttributeName:font,NSForegroundColorAttributeName:color} ;
}
- (void)initTitle:(NSString *)title color:(UIColor *)color{
    [self initTitle:title color:color font:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]];
}
- (void)initTitle:(NSString *)title{
    //这个里的color可以根据项目的主题色调一下
    [self initTitle:title color:[UIColor blackColor] font:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]];
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
    [self initRightBarStr:title color:color font:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
}
- (void)initRightBarStr:(NSString*)title{
    [self initRightBarStr:title color:[UIColor redColor]];
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
    [self initLeftBarStr:title color:color font:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]];
}
- (void)initLeftBarStr:(NSString*)title{
    [self initLeftBarStr:title color:[UIColor redColor]];
}
- (void)initLeftBarImg:(UIImage*)img{
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(leftBarClick)];
}
- (void)leftBarClick{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)setItemPaddingDefault{
    [self setItemPadding:5];
}

- (void)setItemPadding:(CGFloat)padding{
    UINavigationBar * navBar=self.navigationController.navigationBar;
    for (UIView * view in navBar.subviews) {
        for (NSLayoutConstraint *c  in view.constraints) {
//            NSLog(@"%f",c.constant);
            if (c.constant==12||c.constant==8) {
                c.constant=padding;
            }else if (c.constant==-12||c.constant==-8){
                c.constant=-padding;
            }
        }
    }
}

- (void)setNavTrans{
    self.navigationController.navigationBar.translucent = true;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:KClearColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setClipsToBounds:YES];
    self.navigationController.navigationBar.backgroundColor=KClearColor;
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateNavItem];
    });
    return [self getLeftBarItem];
}

- (UIBarButtonItem*)getLeftBarItem{
    return [self createItemImg:IMAGE(@"nav_back") action:@selector(leftBarClick)];
}

- (void)updateNavItem{
    [self setItemPaddingDefault];
}


@end
