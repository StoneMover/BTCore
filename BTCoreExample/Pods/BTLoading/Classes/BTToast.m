//
//  BTToast.m
//  loadinghelp
//
//  Created by stonemover on 2018/8/11.
//  Copyright © 2018年 StoneMover. All rights reserved.
//

#import "BTToast.h"
#import "BTLoadingHelp.h"


static const CGFloat BT_TOAST_PADDING=12;

static const CGFloat BT_TOAST_IMG_LABEL_TOP=5;


@interface BTToast()<BTLoadingHelpDelegate>

@property (nonatomic, strong) NSString * contentStr;

@property (nonatomic, strong) UIImage * contentImg;

@property (nonatomic, assign) BTToastStyle style;

@property (nonatomic, strong) UILabel * labelContent;

@property (nonatomic, strong) UIImageView * imgViewType;

@property (nonatomic, strong) UIView * rootView;


@end


@implementation BTToast


+ (BTToast*)show:(NSString*)str{
    return [self show:str img:nil];
}

+ (BTToast*)show:(NSString*)str img:(UIImage*)img{
    BTToast * toast=[[BTToast alloc] init:BTToastStyleCenter str:str img:img];
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    [toast show:window];
    return toast;
}

+ (BTToast*)showSuccess:(NSString*)str{
    return [self show:str img:[self imageBundleName:@"bt_toast_success"]];
}

+ (BTToast*)showWarning:(NSString*)str{
    return [self show:str img:[self imageBundleName:@"bt_toast_warning"]];
}

+ (BTToast*)showError:(NSString*)str{
    return [self show:str img:[self imageBundleName:@"bt_toast_error"]];
}

+ (BTToast*)showErrorObj:(NSError*)error{
    NSString * info=nil;
    if ([error.userInfo.allKeys containsObject:@"NSLocalizedDescription"]) {
        info=[error.userInfo objectForKey:@"NSLocalizedDescription"];
    }else {
        info=error.domain;
    }
    return [self showError:info];
}

#pragma mark init
- (instancetype)init:(BTToastStyle)style str:(NSString*)str img:(UIImage*)img{
    self=[super initWithFrame:[UIScreen mainScreen].bounds];
    self.style=style;
    self.contentStr=str;
    self.contentImg=img;
    self.backgroundColor=[UIColor clearColor];
    [self initSelf];
    return self;
}

- (void)initSelf{
    [[BTLoadingHelp share]addDelegate:self];
    self.isClickInToast=YES;
    self.delayDismissTime=1.5;
    [self initRootView];
    [self initLabel];
    [self initImg];
}

- (void)initRootView{
    self.rootView=[[UIView alloc] init];
    self.rootView.alpha=0;
    self.rootView.layer.cornerRadius=5;
    self.rootView.clipsToBounds=YES;
    [self addSubview:self.rootView];
    self.rootView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.85];
}

- (void)initImg{
    if (!self.contentImg) {
        return;
    }
    
    self.imgViewType=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.imgViewType.image=self.contentImg;
    [self.rootView addSubview:self.imgViewType];
}

- (void)initLabel{
    self.labelContent=[[UILabel alloc] init];
    self.labelContent.textColor=[UIColor whiteColor];
    self.labelContent.font=[UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    self.labelContent.textAlignment=NSTextAlignmentCenter;
    self.labelContent.text=self.contentStr;
    self.labelContent.numberOfLines=0;
    [self.labelContent sizeToFit];
    CGFloat labelMaxW=[UIScreen mainScreen].bounds.size.width/2;
    if (self.labelContent.frame.size.width>labelMaxW) {
        CGFloat h=[self calculateStrHeight:self.contentStr withWidth:labelMaxW withFont:self.labelContent.font];
        self.labelContent.frame=CGRectMake(0, 0, labelMaxW, h);
    }
    [self.rootView addSubview:self.labelContent];
}



#pragma mark 布局
- (void)layoutSubviews{
    CGFloat labelW=self.labelContent.frame.size.width;
    CGFloat labelH=self.labelContent.frame.size.height;
    
    CGFloat totalW=labelW+BT_TOAST_PADDING*2;
    CGFloat totalH=labelH+BT_TOAST_PADDING*2;
    if (self.imgViewType) {
        totalH+=BT_TOAST_IMG_LABEL_TOP+self.imgViewType.frame.size.height;
    }
    
    self.rootView.frame=CGRectMake(0,0,totalW,totalH);
    self.rootView.center=CGPointMake(self.frame.size.width/2, (self.frame.size.height-[BTLoadingHelp share].keyboardHeight)/2);
    
    if (self.imgViewType) {
        self.imgViewType.frame=CGRectMake(totalW/2-self.imgViewType.frame.size.width/2,
                                          BT_TOAST_PADDING,
                                          self.imgViewType.frame.size.width,
                                          self.imgViewType.frame.size.height);
        self.labelContent.frame=CGRectMake(BT_TOAST_PADDING,
                                           self.imgViewType.frame.origin.y+self.imgViewType.frame.size.height+BT_TOAST_IMG_LABEL_TOP,
                                           self.labelContent.frame.size.width,
                                           self.labelContent.frame.size.height);
    }else{
        self.labelContent.frame=CGRectMake(BT_TOAST_PADDING,
                                           BT_TOAST_PADDING,
                                           self.labelContent.frame.size.width,
                                           self.labelContent.frame.size.height);
    }
    
    
}

#pragma mark 显示
- (void)show:(UIView *)rootView{
    
    for (UIView * view in rootView.subviews) {
        if ([view isKindOfClass:[BTToast class]]) {
            view.hidden=YES;
        }
    }
    
    self.frame=rootView.bounds;
    [rootView addSubview:self];
    [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.rootView.alpha=1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayDismissTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.2 animations:^{
                self.rootView.alpha=0;
            } completion:^(BOOL finished) {
                [[BTLoadingHelp share]removeDelegate:self];
                [self removeFromSuperview];
            }];
        });
    }];
//    [UIView animateWithDuration:.5 animations:^{
//
//    } completion:^(BOOL finished) {
//
//    }];
    
    
}

#pragma mark 相关方法
-(CGFloat)calculateStrHeight:(NSString*)str withWidth:(CGFloat)width withFont:(UIFont*)font{
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize labelSize =[str boundingRectWithSize:CGSizeMake(width, 1500) options:NSStringDrawingUsesLineFragmentOrigin  attributes:dic context:nil].size;
    return labelSize.height;
}

- (void)setIsClickInToast:(BOOL)isClickInToast{
    self.userInteractionEnabled=!isClickInToast;
}



- (void)keyBoradHeightChange{
    [UIView animateWithDuration:.25 animations:^{
        self.rootView.center=CGPointMake(self.frame.size.width/2, (self.frame.size.height-[BTLoadingHelp share].keyboardHeight)/2);
    }];
}

+ (UIImage*)imageBundleName:(NSString*)name{
    NSString * resourcePath=[[NSBundle mainBundle] resourcePath];
    NSString * bundlePath=[resourcePath stringByAppendingPathComponent:@"BTLoadingBundle.bundle"];
    NSString * imgPath=[bundlePath stringByAppendingPathComponent:name];
    UIImage * img=[[UIImage alloc] initWithContentsOfFile:imgPath];
    return img;
}

@end
