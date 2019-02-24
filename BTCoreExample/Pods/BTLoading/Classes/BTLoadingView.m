//
//  LoadingHelpView.m
//  Base
//
//  Created by whbt_mac on 15/11/3.
//  Copyright © 2015年 StoneMover. All rights reserved.
//

#import "BTLoadingView.h"
#import "UIImage+BTGIF.h"
@interface BTLoadingView()

@property(nonatomic,assign)int w;

@property(nonatomic,assign)int h;

//加载中图片，最好是个gif
@property (nonatomic, strong) UIImage * loadingGif;

//加载中文字
@property (nonatomic, strong) NSString * loadingStr;

//空数据图片
@property (nonatomic, strong) UIImage * emptyImg;

//空数据文字提示
@property (nonatomic, strong) NSString * emptyStr;


//数据错误图片
@property (nonatomic, strong) UIImage * errorImg;

//错误提示
@property (nonatomic, strong) NSString * errorInfo;

//是否正在显示中
@property (nonatomic, assign) BOOL isShow;

@end

@implementation BTLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    self.backgroundColor=[UIColor whiteColor];
    self.w=self.frame.size.width;
    self.h=self.frame.size.height;
    self.loadingGif=[UIImage animatedGIFNamed:@"bt_loading_icon"];
    self.emptyImg=[self imageBundleName:@"bt_loading_empty"];
    self.errorImg=[self imageBundleName:@"bt_loading_error"];
    self.loadingStr=@"玩命加载中...";
    self.emptyStr=@"貌似这里什么都没有";
    self.errorInfo=@"似乎断开了与互联网的连接";
    [self crateLabel];
    [self createImg];
    [self createBtn];
    return self;
}

- (void)crateLabel{
    self.labelText=[[UILabel alloc]init];
    self.labelText.textAlignment=NSTextAlignmentCenter;
    self.labelText.numberOfLines=0;
    self.labelText.text=self.loadingStr;
    self.labelText.translatesAutoresizingMaskIntoConstraints=NO;
    self.labelText.font=[UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    self.labelText.textColor=[UIColor colorWithRed:120/255.0 green:121/255.0 blue:122/255.0 alpha:1];
    [self addSubview:self.labelText];
    NSLayoutConstraint * centerY=[NSLayoutConstraint constraintWithItem:self.labelText attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-20];
    NSLayoutConstraint * left=[NSLayoutConstraint constraintWithItem:self.labelText attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:40];
    NSLayoutConstraint * right=[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.labelText attribute:NSLayoutAttributeRight multiplier:1 constant:40];
    [self addConstraints:@[centerY,left,right]];
}

- (void)createImg{
    self.imgViewLoading=[[UIImageView alloc]init];
    [self addSubview:self.imgViewLoading];
    self.imgViewLoading.translatesAutoresizingMaskIntoConstraints=NO;
    NSLayoutConstraint * top=[NSLayoutConstraint constraintWithItem:self.labelText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imgViewLoading attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    
    NSLayoutConstraint * centerX=[NSLayoutConstraint constraintWithItem:self.imgViewLoading attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    
    
    [self addConstraint:top];
    [self addConstraint:centerX];
    
}

- (void)createBtn{
    self.btnReload=[[UIButton alloc]init];
    self.btnReload.translatesAutoresizingMaskIntoConstraints=NO;
    self.btnReload.backgroundColor=[UIColor colorWithRed:106/255.0 green:179/255.0 blue:250/255.0 alpha:1];
    self.btnReload.layer.cornerRadius=8;
    self.btnReload.titleLabel.font=[UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [self.btnReload setTitle:@"刷新" forState:UIControlStateNormal];
    [self.btnReload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnReload addTarget:self action:@selector(reloadClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnReload];
    
    NSLayoutConstraint * top=[NSLayoutConstraint constraintWithItem:self.btnReload attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.labelText attribute:NSLayoutAttributeBottom multiplier:1 constant:35];
    
    NSLayoutConstraint * centerX=[NSLayoutConstraint constraintWithItem:self.btnReload attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint * x=[NSLayoutConstraint constraintWithItem:self.btnReload attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:110];
    NSLayoutConstraint * y=[NSLayoutConstraint constraintWithItem:self.btnReload attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:45];
    
    [self addConstraint:top];
    [self addConstraint:centerX];
    [self.btnReload addConstraint:x];
    [self.btnReload addConstraint:y];
}

- (void)reloadClick{
    if (self.block) {
        self.block();
    }
}



#pragma mark loadingView
-(void)showLoading{
    [self showLoading:self.loadingStr];
}
-(void)showLoading:(NSString*)loadingStr{
    [self showLoading:loadingStr withImg:self.loadingGif];
}
-(void)showLoading:(NSString*)loadingStr withImg:(UIImage*)img{
    self.isShow=YES;
    self.hidden=NO;
    self.labelText.text=loadingStr;
    self.btnReload.hidden=YES;
    self.imgViewLoading.image=img;
}

#pragma mark loadingEmpty

-(void)showEmpty{
    [self showEmpty:self.emptyStr];
}

-(void)showEmpty:(NSString*)emptyStr{
    [self showEmpty:emptyStr withImg:self.emptyImg];
}

-(void)showEmpty:(NSString*)emptyStr withImg:(UIImage*)img{
    self.isShow=YES;
    self.hidden=NO;
    self.labelText.text=emptyStr;
    self.btnReload.hidden=NO;
    self.imgViewLoading.image=img;
}




#pragma mark loadError
-(void)showError:(NSString*)errorStr withImg:(UIImage*)img{
    self.isShow=YES;
    self.hidden=NO;
    self.labelText.text=errorStr;
    self.btnReload.hidden=NO;
    self.imgViewLoading.image=img;
}
-(void)showError:(NSString*)errorStr{
    [self showEmpty:errorStr withImg:self.errorImg];
}
-(void)showError{
    [self showError:self.errorInfo];
}

#pragma mark NSError type
- (void)showErrorObj:(NSError*)error withImg:(UIImage*)img{
    NSString * info=nil;
    if ([error.userInfo.allKeys containsObject:@"NSLocalizedDescription"]) {
        info=[error.userInfo objectForKey:@"NSLocalizedDescription"];
    }else {
        info=error.domain;
    }
    [self showError:info withImg:img];
}

- (void)showErrorObj:(NSError*)error{
    [self showErrorObj:error withImg:self.errorImg];
}


-(void)dismiss{
    [self dismiss:YES];
}
-(void)dismiss:(BOOL)anim{
    self.isShow=NO;
    if (anim) {
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self setAlpha:0];
        } completion:^(BOOL finished) {
            if(!self.isShow){
                self.hidden=YES;
                [self setAlpha:1];
            }
        }];
    }else{
        self.hidden=YES;
    }
}


- (UIImage*)imageBundleName:(NSString*)name{
    NSString * resourcePath=[[NSBundle mainBundle] resourcePath];
    NSString * bundlePath=[resourcePath stringByAppendingPathComponent:@"BTLoadingBundle.bundle"];
    NSString * imgPath=[bundlePath stringByAppendingPathComponent:name];
    UIImage * img=[[UIImage alloc] initWithContentsOfFile:imgPath];
    return img;
}

    
@end
